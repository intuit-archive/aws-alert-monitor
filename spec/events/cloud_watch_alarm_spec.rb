require 'spec_helper'

describe AwsAlertMonitor::Events::CloudWatchAlarm do

  let(:message) { fixture_file('cloud_watch_alarm.json') }
  let(:event) { AwsAlertMonitor::Events::CloudWatchAlarm.new message }

  describe 'body' do
    it 'returns the body' do
      data = "received alert: \n\n "
      data << "Queue depth alarm for LC notification queue \n\n "
      data << "Threshold Crossed: 1 datapoint (3.0) was greater than the threshold (2.0). \n\n "
      data << "At 2013-01-30T22:00:50.630+0000"
      event.body.should == data
    end
  end

  describe 'subject' do
    it 'returns the subject' do
      event.subject.should == 'Alert: lc-pod-2-dev-1-alarm-1-QueueDepthAlarm-706AQ69BSSN1'
    end
  end

  describe 'type' do
    it 'returns the type' do
      event.type.should == 'cloudwatch:AWS/SQS-ApproximateNumberOfMessagesVisible'
    end
  end

end
