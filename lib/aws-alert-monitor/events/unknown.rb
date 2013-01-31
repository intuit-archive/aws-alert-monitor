module AwsAlertMonitor
  module Events

    class Unknown < Event

      def body
        "received an alert: \n\n #{raw_data.to_s}"
      end

      def subject
        "Alert: unknown type"
      end

      def type
        'unknown'
      end

    end

  end
end
