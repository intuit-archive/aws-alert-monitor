require 'spec_helper'

describe AwsAlertMonitor::Emailer do

  describe 'send_email' do
    let(:ses_mock) { mock 'ses' }
    let(:args) do
      { 'body'    => 'foo bar',
        'emailer' => ses_mock,
        'from'    => 'root@example.com',
        'subject' => 'my subject',
        'to'      => ['bob@example.com', 'joe@example.com'] }
    end

    it 'sends the email with the correct info' do
      data = { :source      => args['from'],
               :destination => { :to_addresses => args['to'] },
               :message     => {
                 :subject => { :data => args['subject'] },
                 :body    => { :text => { :data => args['body']}} }
      }
      ses_mock.should_receive(:send_email).with(data)

      AwsAlertMonitor::Emailer.new(args).send_email
    end

  end

end
