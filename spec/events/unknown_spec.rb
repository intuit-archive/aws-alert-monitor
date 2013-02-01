require 'spec_helper'

describe AwsAlertMonitor::Events::Unknown do

  let(:message) { '{"foo": "bar"}' }
  let(:event) { AwsAlertMonitor::Events::Unknown.new message }

  describe 'body' do
    it 'returns the body' do
      data = "received an alert: \n\n "
      data << JSON.parse(message).to_s
      event.body.should == data
    end
  end

  describe 'subject' do
    it 'returns the subject' do
      event.subject.should == 'Alert: unknown type'
    end
  end

  describe 'type' do
    it 'returns the type' do
      event.type.should == 'unknown'
    end
  end

end
