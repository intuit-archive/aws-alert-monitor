module AwsAlertMonitor
  module AWS
    class SES

      def send_email(args)
        ses.send_email :source      => args[:source],
                       :destination => args[:destination],
                       :message     => args[:message]
      end

      private

      def ses
        ::AWS::SimpleEmailService::Client.new 
      end
    end
  end
end
