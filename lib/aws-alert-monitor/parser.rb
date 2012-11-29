module AwsAlertMonitor
  class Parser

    def initialize
      @config        = AwsAlertMonitor::Config.new
      @config_file   = @config.file
      @logger        = @config.logger
    end

    def run
      @config_file.keys.each do |key|
        AWS.config :access_key_id     => @config_file[key][access_key],
                   :secret_access_key => @config_file[key][secret_key]

        sqs_endpoint = @config_file[key][sqs_endpoint]
        @logger.info "Receiving messages from #{sqs_endpoint}"

        count = sqs.approximate_number_of_messages sqs_endpoint
        @logger.info "Approximatley #{count} messages available."

        message = sqs.receive_message sqs_endpoint 

        if message
          alert.process message.body
          message.delete
        end
      end
    end

    private

    def alert
      @alert ||= AwsAlertMonitor::Alert.new :config => @config
    end

    def sqs
      @sqs ||= AwsAlertMonitor::AWS::SQS.new :config => @config
    end
  end
end
