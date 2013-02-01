require 'spec_helper'

describe AwsAlertMonitor::Events::AutoScalingNotification do

  let(:message) { fixture_file('asg_instance_launch.json') }
  let(:event) { AwsAlertMonitor::Events::AutoScalingNotification.new message }

  describe 'body' do
    it 'returns the body' do
      data = "received an alert: \n\n "
      data << "Launching a new EC2 instance: i-d6a2cb8f \n\n "
      data << "At 2012-11-29T16:39:05Z an instance was started in response to a"
      data << " difference between desired and actual capacity,"
      data << " increasing the capacity from 0 to 1."
      event.body.should == data
    end
  end

  describe 'subject' do
    it 'returns the subject' do
      data = 'Alert: Auto Scaling: launch for group '
      data << '"lc-pod-2-qa-1-app-1-Instances-XCYGCEQC0H02"'
      event.subject.should == data
    end
  end

  describe 'type' do
    it 'returns the type' do
      event.type.should == 'autoscaling:EC2_INSTANCE_LAUNCH'
    end
  end

end
