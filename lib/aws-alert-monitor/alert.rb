require 'json'

module AwsAlertMonitor
  class Alert

    def initialize(args)
      @config = args[:config]
      @logger = @config.logger
    end

    def process(args)
      message_body    = JSON.parse args[:body]
      events          = args[:events]
      message         = JSON.parse message_body['Message']
      message_cause   = message['Cause']
      message_event   = message['Event']
      message_subject = message['Description']

      events.each_pair do |event, policy|

        @logger.info "Evaluating #{message_event} against #{event}"

        if event == message_event
          message_source      = policy['email']['source']
          message_destination = policy['email']['destination']

          @logger.info "Sending alert to #{message_destination}."

          options = { :source      => message_source,
                      :destination => { :to_addresses => [ message_destination ] },
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
