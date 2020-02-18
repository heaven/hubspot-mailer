# frozen_string_literal: true

module Hubspot
  class Mailer < ActionMailer::Base
    abstract!

    register_preview_interceptor(HubspotPreviewInterceptor)

    # Register our own delivery method
    add_delivery_method :hubspot, Delivery

    # Set hubspot as a default delivery method
    self.delivery_method = :hubspot

    # Set credentials
    # self.hubspot_settings = { :hapikey => ENV.fetch("HUBSPOT_API_KEY") }

    self.default_params = {}.freeze

    SINGLE_SEND_PATH = "/email/public/v1/singleEmail/send"

    class << self
      # Wraps an email delivery inside of <tt>ActiveSupport::Notifications</tt> instrumentation.
      #
      # This method is actually called by the <tt>Mail::Message</tt> object itself
      # through a callback when you call <tt>:deliver</tt> on the <tt>Mail::Message</tt>,
      # calling +deliver_mail+ directly and passing a <tt>Mail::Message</tt> will do
      # nothing except tell the logger you sent the email.
      def deliver_mail(mail) #:nodoc:
        ActiveSupport::Notifications.instrument("deliver.hubspot_mailer") do |payload|
          set_payload_for_mail(payload, mail)
          yield # Let Mail do the delivery actions
        end
      end

      # Perform the delivery by calling Hubspot's API
      #
      # Receives regular mail object that contains additional template details.
      def single_send(mail)
        # Format the request data
        data = single_send_params(mail)

        # Call the API
        response = Hubspot::Connection.post_json(SINGLE_SEND_PATH, params: {}, body: data)

        # Parse response and either raise or return event details
        parse_response(response)
      end

      private

      def set_payload_for_mail(payload, mail)
        payload[:mailer]     = name
        payload[:message_id] = mail.message_id
        payload[:subject]    = mail.subject
        payload[:to]         = mail.to
        payload[:from]       = mail.from     if mail.from.present?
        payload[:send_id]    = mail.send_id  if mail.send_id.present?
        payload[:reply_to]   = mail.reply_to if mail.reply_to.present?
        payload[:cc]         = mail.cc       if mail.cc.present?
        payload[:bcc]        = mail.bcc      if mail.bcc.present?
      end

      def single_send_params(mail)
        raise MissingTemplateError, "Missing emailId parameter." unless mail.email_id.present?
        raise MissingRecipientError, "Missing recipient email."  unless mail.to.present?

        data = {
          emailId: mail.email_id,
          message: { to: mail.to.first }
        }

        data[:message][:from]   = mail.from.first if mail.from.present?
        data[:message][:cc]     = mail.cc         if mail.cc.present?
        data[:message][:bcc]    = mail.bcc        if mail.bcc.present?
        data[:message][:sendId] = mail.send_id    if mail.send_id.present?

        if mail.reply_to.present?
          if mail.reply_to.size > 1
            data[:message][:replyToList] = mail.reply_to
          else
            data[:message][:replyTo] = mail.reply_to.first
          end
        end

        # Copy subject from header to custom property
        if mail.subject.present? && !mail.custom_properties.try(:[], :subject)
          mail.custom_properties ||= {}
          mail.custom_properties[:subject] = mail.subject
        end

        if mail.contact_properties.present?
          data[:contactProperties] =
            Hubspot::Utils.hash_to_properties(mail.contact_properties, key_name: :name)
        end

        if mail.custom_properties.present?
          data[:customProperties] =
            Hubspot::Utils.hash_to_properties(mail.custom_properties, key_name: :name)
        end

        data
      end

      def parse_response(response)
        status_code = response["sendResult"]

        case status_code
        when "SENT", "QUEUED"
          response["eventId"]
        when "INVALID_TO_ADDRESS"
          raise RecipientAddressError.new(response), "The TO address is invalid: #{status_code}"
        when "INVALID_FROM_ADDRESS"
          raise SenderAddressError.new(response), "The FROM address is invalid: #{status_code}"
        when "BLOCKED_DOMAIN", "PORTAL_SUSPENDED"
          raise SendingError.new(response), "Message can't be sent: #{status_code}"
        when "PREVIOUSLY_BOUNCED", "PREVIOUS_SPAM"
          raise DeliveryError.new(response), "Message can't be delivered: #{status_code}"
        when "MISSING_CONTENT"
          raise InvalidTemplateError.new(response),
                "The emailId is invalid, or the emailId is an email that is not set up for Single Send: #{status_code}"
        else
          raise UnknownResponseError.new(response), "Unrecognized status code: #{status_code}"
        end
      end
    end

    attr_internal :message

    def initialize
      super()
      @_mail_was_called = false
      @_message         = Message.new
    end

    def process(method_name, *args) #:nodoc:
      payload = {
        mailer: self.class.name,
        action: method_name,
        args:   args
      }

      ActiveSupport::Notifications.instrument("process.hubspot_mailer", payload) do
        super
        @_message = ActionMailer::Base::NullMail.new unless @_mail_was_called
      end
    end

    def mail(headers = {}, &block)
      return message if @_mail_was_called && headers.blank? && !block

      headers = apply_defaults(headers)

      # Set configure delivery behavior
      wrap_delivery_behavior!(headers[:delivery_method], headers[:delivery_method_options])

      # Hubspot-specific attributes, e.g. emailId (template ID)
      assign_attributes_to_message(message, headers)

      # Default headers
      assign_headers_to_message(message, headers)

      @_mail_was_called = true

      message
    end

    private

    def assign_attributes_to_message(message, headers)
      hubspot_props = %i[email_id send_id contact_properties custom_properties]

      headers.slice(*hubspot_props).each { |k, v| message.try("#{k}=", v) }
      headers.except!(*hubspot_props)
    end

    def assign_headers_to_message(message, headers)
      headers.except(:parts_order, :content_type, :body, :template_name,
                     :template_path, :delivery_method, :delivery_method_options)
             .each { |k, v| message[k] = v }
    end
  end
end
