require 'spec_helper'

describe AwsAlertMonitor::EventClassifier do
  let(:message) { fixture_file('asg_instance_launch.json') }
  let(:classifier) { AwsAlertMonitor::EventClassifier.new message }

  describe 'event' do

    it 'returns the appropriate event object' do
      classifier.event.type.should == 'autoscaling:EC2_INSTANCE_LAUNCH'
    end

  end

end
