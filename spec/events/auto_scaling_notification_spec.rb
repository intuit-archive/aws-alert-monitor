require 'spec_helper'

describe AwsAlertMonitor::Events::AutoScalingNotification do

  let(:message) { fixture_file('asg_instance_launch.json') }
  let(:event) { AwsAlertMonitor::Events::AutoScalingNotification.new message }

  describe 'body' do
    it 'returns the body' do
      event.body.should == "received alert: \n\n Launching a new EC2 instance: i-d6a2cb8f \n\n At 2012-11-29T16:39:05Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 0 to 1."
    end
  end

  describe 'subject' do
    it 'returns the subject' do
      event.subject.should == 'Alert: Auto Scaling: launch for group "lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02"'
    end
  end

  describe 'type' do
    it 'returns the type' do
      event.type.should == 'autoscaling:EC2_INSTANCE_LAUNCH'
    end
  end

end
