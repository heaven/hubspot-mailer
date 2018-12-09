module Hubspot
  class Mailer < ActionMailer::Base
    class MissingTemplateError < StandardError; end
    class MissingRecipientError < StandardError; end

    class RequestError < StandardError
      attr_reader :response

      def initialize(response = nil)
        @response = response
      end
    end

    class RecipientAddressError < RequestError; end
    class SenderAddressError < RequestError; end
    class SendingError < RequestError; end
    class DeliveryError < RequestError; end
    class InvalidTemplateError < RequestError; end
    class UnknownResponseError < RequestError; end
  end
end
