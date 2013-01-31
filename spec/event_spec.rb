require 'spec_helper'

describe AwsAlertMonitor::Event do
  let(:event) do
    data = '{ "foo": "bar", "Message": "{ \"a\": \"b\" }"}'
    AwsAlertMonitor::Event.new data
  end

  describe 'raw_data' do
    it 'provides the raw parsed data' do
      event.raw_data.should == { 'foo' => 'bar', 'Message' => '{ "a": "b" }' }
    end
  end

  describe 'message_data' do
    it 'provides the message data' do
      event.message_data.should == { 'a' => 'b' }
    end
  end

end
