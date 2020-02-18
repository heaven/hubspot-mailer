# frozen_string_literal: true

module Hubspot
  class Mailer < ActionMailer::Base
    class Delivery
      attr_accessor :settings

      DEFAULTS = {}.freeze

      def initialize(values)
        self.settings = DEFAULTS.merge(values)
      end

      def deliver!(mail)
        Hubspot::Mailer.single_send(mail)
      end
    end
  end
end
