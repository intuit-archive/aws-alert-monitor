require 'spec_helper'

describe AwsAlertMonitor::Parser do

  it "should run the parser against the given config" do
    data = "app:\n  access_key: key \n  secret_key: secret\n  region: us-west-1\n  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/123456789012/app\n  events: \n    'autoscaling:EC2_INSTANCE_LAUNCH':\n      email:\n        source: brett_weaver@intuit.com\n        destination: brett_weaver@intuit.com\n"
    @logger_stub = stub 'logger', :debug => true, 
                                  :info => true
    @config_stub = stub 'config', :logger => @logger_stub,
                                  :file   => YAML.load(data)
    AwsAlertMonitor::Config.stub :new => @config_stub
    @parser = AwsAlertMonitor::Parser.new :log_level => 'debug'

    @alert_mock   = mock 'alert'
    @sqs_mock     = mock 'sqs'
    @message_mock = mock 'message'
    ::AWS.should_receive(:config).with :access_key_id     => 'key',
                                       :secret_access_key => 'secret'
    AwsAlertMonitor::Alert.should_receive(:new).
                           with(:config => @config_stub).
                           and_return @alert_mock
    AwsAlertMonitor::AWS::SQS.stub :new => @sqs_mock
    @sqs_mock.should_receive(:approximate_number_of_messages).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              and_return 1
    @sqs_mock.should_receive(:receive_message).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              exactly(2).times.
              and_return @message_mock
    @sqs_mock.should_receive(:receive_message).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              and_return false
    @message_mock.stub :body => 'body'
    @alert_mock.should_receive(:process).
                with({:name => "app", :message=>"body", :events=>{"autoscaling:EC2_INSTANCE_LAUNCH"=>{"email"=>{"source"=>"brett_weaver@intuit.com", "destination"=>"brett_weaver@intuit.com"}}}}).
                exactly(2).times
    @message_mock.should_receive(:delete).exactly(2).times
    @parser.run
  end

  it "should use a proxy if specified" do
    data = "app:\n  access_key: key \n  secret_key: secret\n  region: us-west-1\n  sqs_endpoint: https://sqs.us-west-1.amazonaws.com/123456789012/app\n  proxy_uri: http://proxy.com\n  events: \n    'autoscaling:EC2_INSTANCE_LAUNCH':\n      email:\n        source: brett_weaver@intuit.com\n        destination: brett_weaver@intuit.com\n"
    @logger_stub = stub 'logger', :debug => true,
                                  :info => true
    @config_stub = stub 'config', :logger => @logger_stub,
                                  :file   => YAML.load(data)
    AwsAlertMonitor::Config.stub :new => @config_stub
    @parser = AwsAlertMonitor::Parser.new :log_level => 'debug'
    @alert_mock   = mock 'alert'
    @sqs_mock     = mock 'sqs'
    @message_mock = mock 'message'
    ::AWS.should_receive(:config).with :access_key_id     => 'key',
                                       :secret_access_key => 'secret',
                                       :proxy_uri         => 'http://proxy.com'
    AwsAlertMonitor::Alert.should_receive(:new).
                           with(:config => @config_stub).
                           and_return @alert_mock
    AwsAlertMonitor::AWS::SQS.stub :new => @sqs_mock
    @sqs_mock.should_receive(:approximate_number_of_messages).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              and_return 1
    @sqs_mock.should_receive(:receive_message).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              exactly(2).times.
              and_return @message_mock
    @sqs_mock.should_receive(:receive_message).
              with('https://sqs.us-west-1.amazonaws.com/123456789012/app').
              and_return false
    @message_mock.stub :body => 'body'
    @alert_mock.should_receive(:process).
                with({:name => "app", :message=>"body", :events=>{"autoscaling:EC2_INSTANCE_LAUNCH"=>{"email"=>{"source"=>"brett_weaver@intuit.com", "destination"=>"brett_weaver@intuit.com"}}}}).
                exactly(2).times
    @message_mock.should_receive(:delete).exactly(2).times
    @parser.run
  end

end
