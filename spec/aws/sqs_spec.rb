require 'spec_helper'

describe AwsAlertMonitor::AWS::SQS do
  before do
    @queue_mock  = mock 'queue'
    @sqs = AwsAlertMonitor::AWS::SQS.new
  end

  it "should call receive_message on the given queue url" do
    AWS::SQS::Queue.should_receive(:new).
                    with('http://sqs_url').
                    and_return @queue_mock
    @queue_mock.stub :receive_message => 'da-message'
    @sqs.receive_message('http://sqs_url').should == 'da-message'
  end

  it "should call approximate_number_of_messages on the given queue url" do
    AWS::SQS::Queue.should_receive(:new).
                    with('http://sqs_url').
                    and_return @queue_mock
    @queue_mock.stub :approximate_number_of_messages => 2
    @sqs.approximate_number_of_messages('http://sqs_url').
         should == 2
  end
end
