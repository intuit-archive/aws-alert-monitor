require 'json'

module AwsAlertMonitor
  class Alert

    def initialize(args)
      @config = args[:config]
      @logger = @config.logger
    end

    def process(args)
      message_body    = JSON.parse args[:body]
      message         = JSON.parse message_body['Message']
      message_cause   = message['Cause']
      message_event   = message['Event']
      message_subject = message['Description']

      events.each do |event|
        if event['name'] == message_event
          message_source      = event['source']
          message_destination = event['destination']

          options = { :source      => source,
                      :destination => { :to_addresses => [ destination ] },
                      :message     => { :subject => {
                                          :data => message_subject
                                        },
                                        :body    => {
                                          :text => {
                                            :data => message_cause
                                          }
                                        }
                                      } }

          ses.send_email options
        end
      end
    end

    private

    def ses
      @ses ||= AwsAlertMonitor::AWS::SES.new :config => @config
    end
  end
end
