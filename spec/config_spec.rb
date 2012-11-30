require 'spec_helper'
require 'yaml'

describe AwsAlertMonitor::Config do
  before do
    @data = "app:\n  access_key: key \n  secret_key: secret\n  region: us-west-1\n  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/123456789012/app\n  events: \n    'autoscaling:EC2_INSTANCE_LAUNCH':\n      email:\n        source: brett_weaver@intuit.com\n        destination: brett_weaver@intuit.com\n"
    File.should_receive(:open).
         with("#{ENV['HOME']}/.aws-alert-monitor.yml").
         and_return @data
  end

  it "should load the configuration from ~/.aws-alert-monitor.yml" do
    @config = AwsAlertMonitor::Config.new
    @config.file.should == YAML.load(@data)
  end
end
