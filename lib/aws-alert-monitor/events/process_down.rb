module AwsAlertMonitor
  module Events

    class ProcessDown < Event

      def body
        message = "received an alert: \n\n "
        message << "#{description}\n\n "
        message << "Environment: #{environment}\n\n "
        message << "Host: #{host}\n\n "
        message << "At #{created_at}"
      end

      def subject
        "Alert: process #{process} down #{environment}"
      end

      def type
        'process_down'
      end

      private
      %w[created_at environment host required_count running_count process].each do |m|
        define_method(m) { message_data[m] }
      end

      def description
        message_data['body']
      end

    end

  end
end
