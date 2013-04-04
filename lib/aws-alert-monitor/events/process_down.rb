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
        "Alert: process #{process_name} down #{environment}"
      end

      def type
        'process_down'
      end

      private
      def created_at
        message_data['created_at']
      end

      def description
        message_data['body']
      end

      def environment
        message_data['environment']
      end

      def host
        message_data['host']
      end

      def required_count
        message_data['required_count']
      end

      def running_count
        message_data['running_count']
      end

      def process_name
        message_data['process']
      end

    end

  end
end
