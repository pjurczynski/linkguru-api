module Notifications
  module Slack
    module Base
      extend ActiveSupport::Concern

      included do
        def send_message(message)
          client.ping formatter_class.format(message)
        end
      end

      def client
        @client ||= notifier_class.new Rails.application.secrets.slack_webhook
      end

      def notifier_class
        ::Slack::Notifier
      end

      def formatter_class
        notifier_class::LinkFormatter
      end
    end
  end
end
