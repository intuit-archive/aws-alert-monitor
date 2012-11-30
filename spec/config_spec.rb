require 'spec_helper'
require 'yaml'

describe AwsAlertMontitor::Config do
  before do
    @data = "lc-pod-2-qa-1-app-2:\n  access_key: key \n  secret_key: secret\n  region: us-west-1\n  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/187130254137/lc-pod-2-qa-1-queue-2-Queue-NKE7QCNN0W6A\n  events: \n    'autoscaling:EC2_INSTANCE_LAUNCH':\n      email:\n        source: brett_weaver@intuit.com\n        destination: brett_weaver@intuit.com\n"
    File.stub :open => @data
  end

  it "should load the configuration from ~/.aws-alert-monitor.yml" do
    @config = AwsAlertMontitor::Config.new
    @config.file.should == YAML.parse(@data)
  end
end
