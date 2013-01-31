require 'spec_helper'

describe AwsAlertMonitor::Alert do
  before do
    @message = fixture_file 'asg_instance_launch.json'
    @options = { :name    => 'test app',
                 :message => @message,
                 :events  => {
                   'autoscaling:EC2_INSTANCE_LAUNCH' => {
                     'email' => {
                       'source'      => 'bob_weaver@intuit.com',
                       'destination' => 'brett_weaver@intuit.com'
                  } } }
    }

    @logger_stub  = stub 'logger', :debug => true,
                                   :info  => true,
                                   :error => true
    @config_stub  = stub 'config', :logger => @logger_stub
    @emailer_mock = mock 'emailer'

    @data = { 'body' => "test app received alert: foo",
              'from' => 'bob_weaver@intuit.com',
              'subject' => "Alert: Auto Scaling: launch for bar",
              'to' => ['brett_weaver@intuit.com'] }
    AwsAlertMonitor::Config.stub :new => @config_stub
    @alert = AwsAlertMonitor::Alert.new :config => @config_stub
  end

  it "should process the given message against known events" do
    @event_stub      = stub 'event', :body    => "received alert: foo",
                                     :subject => "Alert: Auto Scaling: launch for bar",
                                     :type    => 'autoscaling:EC2_INSTANCE_LAUNCH'
    @classifier_stub = stub 'classifier', :event => @event_stub
    AwsAlertMonitor::EventClassifier.should_receive(:new).
                                     with(@message).
                                     and_return(@classifier_stub)
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
