module AwsAlertMonitor
  module Events

    class AutoScalingNotification < Event

      def body
        cause       = message_data['Cause']
        description = message_data['Description']
        "received an alert: \n\n #{description} \n\n #{cause}"
      end

      def subject
        "Alert: #{raw_data['Subject']}"
      end

      def type
        message_data['Event']
      end

    end

  end
end
