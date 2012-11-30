require 'optparse'

module AwsAlertMonitor
  class CLI
    def initialize
      @options = parse_options
    end

    def start
      parser = AwsAlertMonitor::Parser.new :log_level => @options[:log_level
      parser.run
    end

    private

    def parse_options
      options = {}

      OptionParser.new do |opts|

        opts.banner = "Usage: aws-alert-monitor.rb [options]"

        opts.on("-l", "--log-level [LOG_LEVEL]", "Log Level") do |l|
          options[:log_level] = l
        end
      end.parse!

      options
    end
  end
end
