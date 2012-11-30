module AwsAlertMonitor
  module AWS
    class SQS

      def receive_message(url)
        queue(url).receive_message 
      end

      def approximate_number_of_messages(url)
        queue(url).approximate_number_of_messages
      end

      private

      def queue(url)
        ::AWS::SQS::Queue.new url
      end
    end
  end
end
