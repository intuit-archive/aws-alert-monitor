module AwsAlertMonitor
  module AWS
    class SQS

      def initialize(args)
        @config = args[:config]
      end

      def receive_message(url)
        sqs.receive_message(url)
      end

      def delete_message(queue_url, receipt_handle)
        sqs.delete_message(queue_url, receipt_handle)
      end

      private

      def sqs
        @sqs ||= Fog::AWS::SQS.new :aws_access_key_id     => @config.access_key,
                                   :aws_access_access_key => @config.secret_key
      end
    end
  end
end
