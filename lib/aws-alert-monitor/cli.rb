module AwsAlertMonitor
  class CLI
    def self.start
      parser = AwsAlertMonitor::Parser.new
      parser.run
    end
  end
end
