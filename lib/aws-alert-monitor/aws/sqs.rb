require 'fog'

module AwsAlertMonitor
  module Aws
    class Sqs

      def receive_message(url)
        sqs.receive_message(url)
      end

      def delete_message(queue_url, receipt_handle)
        sqs.delete_message(queue_url, receipt_handle)
      end

      private

      def sqs
        @sqs ||= Fog::AWS::SQS.new :aws_access_key_id     => 'test',
                                   :aws_access_access_key => 'test'
      end
    end
  end
end
