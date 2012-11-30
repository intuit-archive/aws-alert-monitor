module AwsAlertMonitor
  class Parser

    def initialize(args)
      log_level      = args[:log_level]
      @config        = AwsAlertMonitor::Config.new :log_level => log_level
      @config_file   = @config.file
      @logger        = @config.logger
    end

    def run
      @config_file.keys.each do |name|
        sqs_endpoint = @config_file[name]['sqs_endpoint']
        access_key   = @config_file[name]['access_key']
        secret_key   = @config_file[name]['secret_key']
        events       = @config_file[name]['events']

        ::AWS.config :access_key_id     => access_key,
                     :secret_access_key => secret_key

        @logger.info "Processing #{name}."
        @logger.debug "Receiving messages from #{sqs_endpoint}"

        count = sqs.approximate_number_of_messages sqs_endpoint
        @logger.info "Approximatley #{count} messages available."

        message = sqs.receive_message sqs_endpoint 

        if message
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
