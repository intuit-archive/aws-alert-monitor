require 'spec_helper'

describe AwsAlertMonitor::Alert do
  before do
    @message = fixture_file 'asg_instance_launch.json'
    @options = { :name    => 'test app',
                 :message => @message,
                 :events  => { 'autoscaling:EC2_INSTANCE_LAUNCH' =>
                               { 'email' => { 'source' => 'bob_weaver@intuit.com', 'destination'=>"brett_weaver@intuit.com"}}}}

    @logger_stub  = stub 'logger', :debug => true,
                                   :info  => true,
                                   :error => true
    @config_stub  = stub 'config', :logger => @logger_stub
    @emailer_mock = mock 'emailer'
    @data = { 'body' => "test app received alert: \n\n Launching a new EC2 instance: i-d6a2cb8f \n\n At 2012-11-29T16:39:05Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 0 to 1.",
              'from' => 'bob_weaver@intuit.com',
              'subject' => "Alert: Auto Scaling: launch for group \"lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02\"",
              'to' => ['brett_weaver@intuit.com'] }
    AwsAlertMonitor::Config.stub :new => @config_stub
    @alert = AwsAlertMonitor::Alert.new :config => @config_stub
  end

  it "should process the given message against known events" do
    AwsAlertMonitor::Emailer.should_receive(:new).
                             with(@data).
                             and_return(@emailer_mock)
    @emailer_mock.should_receive :send_email
    @alert.process @options
  end

  it "should return false if the given message is invalid JSON" do
    @emailer_mock.should_not_receive(:send_email)
    @options[:message] = 'invalid stuff'
    @alert.process(@options).should be_false
  end

  it "should not send the message if the destination is nil" do
    @emailer_mock.should_not_receive(:send_email)
    @options = { :name    => 'test app',
                 :message => @message,
                 :events  => {
                   'autoscaling:EC2_INSTANCE_LAUNCH' => {
                     'email' => { 'source' => 'brett_weaver@intuit.com' }
                    }
                 }
    }
    @alert.process(@options).should be_true
  end

end
