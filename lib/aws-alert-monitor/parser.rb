module AwsAlertMonitor
  class Parser

    def initialize(args)
      log_level      = args[:log_level]
      @config        = AwsAlertMonitor::Config.new :log_level => log_level
      @config_file   = @config.file
      @logger        = @config.logger
    end

    def run
      @config_file.each_pair do |name, data|
        sqs_endpoint = data['sqs_endpoint']
        access_key   = data['access_key']
        secret_key   = data['secret_key']
        events       = data['events']

        ::AWS.config :access_key_id     => access_key,
                     :secret_access_key => secret_key

        @logger.info "Processing #{name}."
        @logger.debug "Receiving messages from #{sqs_endpoint}"

        count = sqs.approximate_number_of_messages sqs_endpoint
        @logger.info "Approximatley #{count} messages available."

        while message = sqs.receive_message(sqs_endpoint)
          alert.process :name    => name,
                        :message => message.body,
                        :events  => events
          @logger.info "Deleting message from queue."
          message.delete
        end
      end
    end

    private

    def alert
      @alert ||= AwsAlertMonitor::Alert.new :config => @config
    end

    def sqs
      @sqs ||= AwsAlertMonitor::AWS::SQS.new
    end
  end
end
