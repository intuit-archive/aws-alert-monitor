module AwsAlertMonitor
  class Parser

    def initialize
      @config = AwsAlertMonitor::Config.new
    end

    def run
      message = sqs.receive_message('test')
    end

    private

    def ses
      @ses ||= AwsAlertMonitor::Aws::SES.new :config => @config
    end

    def sqs
      @sqs ||= AwsAlertMonitor::Aws::Sqs.new :config => @config
    end
  end
end
