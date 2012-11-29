require 'optparse'

module AwsAlertMonitor
  class CLI
    def initialize
      @options = parse_options
    end

    def start
      AwsAlertMonitor::Parser.new.run
    end

    private

    def parse_options
      options = {}

      OptionParser.new do |opts|

        opts.banner = "Usage: aws-alert-monitor.rb [options]"

        opts.on("-s", "--sqs-queue-url [SQS_QUEUE_URL]", "SQS Queue URL") do |s|
          options[:sqs_queue_url] = s
        end
      end.parse!

      options
    end
  end
end
