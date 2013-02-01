require 'spec_helper'

describe AwsAlertMonitor::EventClassifier do

  describe 'event' do

    context 'auto scaling notification' do
      let(:message) { fixture_file('asg_instance_launch.json') }
      let(:classifier) { AwsAlertMonitor::EventClassifier.new message }

      it 'returns the appropriate event object' do
        classifier.event.type.should == 'autoscaling:EC2_INSTANCE_LAUNCH'
      end
    end

    context 'cloud watch alarm' do
      let(:message) { fixture_file('cloud_watch_alarm.json') }
      let(:classifier) { AwsAlertMonitor::EventClassifier.new message }

      it 'returns the appropriate event object' do
        classifier.event.type.should == 'cloudwatch:AWS/SQS-ApproximateNumberOfMessagesVisible'
      end
    end

    context 'unknown' do
      let(:message) { '{ "foo": "bar" }'}
      let(:classifier) { AwsAlertMonitor::EventClassifier.new message }

      it 'returns the appropriate event object' do
        classifier.event.type.should == 'unknown'
      end
    end

  end

end
