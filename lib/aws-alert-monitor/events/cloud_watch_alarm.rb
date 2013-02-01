module AwsAlertMonitor
  module Events

    class CloudWatchAlarm < Event

      def body
        message = "received an alert: \n\n #{alarm_description} \n\n"
        message << " #{alarm_new_state_reason} \n\n"
        message << " At #{alarm_state_change_time}"
      end

      def subject
        "Alert: #{alarm_name}"
      end

      def type
        "cloudwatch:#{metric_namespace}-#{metric_name}"
      end

      private
      def alarm_description
        message_data['AlarmDescription']
      end

      def alarm_name
        message_data['AlarmName']
      end

      def alarm_new_state_reason
        message_data['NewStateReason']
      end

      def alarm_state_change_time
        message_data['StateChangeTime']
      end

      def metric_name
        message_data['Trigger']['MetricName']
      end

      def metric_namespace
        message_data['Trigger']['Namespace']
      end

    end

  end
end
