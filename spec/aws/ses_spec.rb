require 'spec_helper'

describe AwsAlertMonitor::AWS::SES do
  before do
    @ses_mock  = mock 'ses'
    @ses = AwsAlertMonitor::AWS::SES.new
  end

  it "should call send_email with the given args" do
    AWS::SimpleEmailService::Client.stub :new => @ses_mock
    @ses_mock.should_receive(:send_email).
              with :source      => 'src',
                   :destination => 'dest',
                   :message     => 'msg'
    @ses.send_email :source      => 'src',
                    :destination => 'dest',
                    :message     => 'msg'
  end
end
