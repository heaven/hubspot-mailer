# frozen_string_literal: true

module Hubspot
  class Mailer < ActionMailer::Base
    class HubspotPreviewInterceptor
      class << self
        def previewing_email(message)
          new(message).transform!
        end
      end

      attr_reader :message

      def initialize(message)
        @message = message
      end

      def transform!
        build_preview
      end

      private

      def build_preview
        if message.message.is_a?(Hubspot::Mailer::Message)
          html_part = String.new
          html_part << "<b>Email ID (template)</b>: #{message.email_id}<br/><br/>"

          html_part << list_properties("Contact Properties (use via {{contact.propertyname}})", message.contact_properties)
          html_part << list_properties("Custom Properties (use via {{custom.property_name}})", message.custom_properties)

          message.html_part = html_part
        end

        message
      end

      def list_properties(label, list)
        buffer = String.new
        return buffer unless list.present?

        buffer << "<b>#{label}</b>:<ul>"

        list.each_pair do |property, value|
          buffer << "<li><i>#{property}</i>: #{value}</li>"
        end

        buffer << "</ul>"
      end
    end
  end
end
