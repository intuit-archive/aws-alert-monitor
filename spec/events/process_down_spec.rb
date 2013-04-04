require 'spec_helper'

describe AwsAlertMonitor::Events::ProcessDown do

  let(:message) { fixture_file('process_down.json') }
  let(:event) { AwsAlertMonitor::Events::ProcessDown.new message }

  describe 'body' do
    it 'returns the body' do
      data = "received an alert: \n\n "
      data << "Required process foo down. 1 running, 2 required.\n\n "
      data << "Environment: lc-pod-2-dev-1\n\n "
      data << "Host: host1.example.com\n\n "
      data << "At 2013-01-30T22:00:50Z"
      event.body.should == data
    end
  end

  describe 'subject' do
    it 'returns the subject' do
      event.subject.should == 'Alert: process foo down lc-pod-2-dev-1'
    end
  end

  describe 'type' do
    it 'returns the type' do
      event.type.should == 'process_down'
    end
  end

end
