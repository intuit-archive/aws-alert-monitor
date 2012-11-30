require 'json'

module AwsAlertMonitor
  class Alert

    def initialize(args)
      @config = args[:config]
      @logger = @config.logger
    end

    def process(args)
      events  = args[:events]
      message = args[:message]

      process_message message

      events.each_pair do |event, policy|
        @logger.info "Evaluating '#{@message_event}' against '#{event}'"
        send_alert policy if event == @message_event
      end
    end

    private

    def send_alert(policy)
      message_source      = policy['email']['source']
      message_destination = policy['email']['destination']

      @logger.info "Sending alert to #{message_destination}."

      options = { :source      => message_source,
                  :destination => { :to_addresses => [ message_destination ] },
                  :message     => { :subject => {
                                      :data => @message_subject
                                    },
                                    :body    => {
                                      :text => {
                                        :data => @message_cause
                                      }
                                    }
                                  } 
                }
      ses.send_email options
    end

    def process_message(message)
      message_body    = JSON.parse message
      message         = JSON.parse message_body['Message']
      @message_cause   = message['Cause']
      @message_event   = message['Event']
      @message_subject = message['Description']
    end

    def ses
      @ses ||= AwsAlertMonitor::AWS::SES.new
    end
  end
end
