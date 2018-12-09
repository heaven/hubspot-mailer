module Hubspot
  class Mailer < ActionMailer::Base
    class Message < Mail::Message
      attr_accessor :email_id
      attr_accessor :send_id
      attr_accessor :contact_properties
      attr_accessor :custom_properties
    end
  end
end
