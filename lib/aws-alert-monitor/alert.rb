require 'json'

module AwsAlertMonitor
  class Alert

    def initialize(args)
      @config = args[:config]
      @logger = @config.logger
    end

    def process(args)
      @name    = args[:name]
      @events  = args[:events]
      @message = args[:message]

      unless process_message @message
        @logger.error "Unable to process message."
        return false
      end

      @events.each_pair do |event, policy|
        @logger.info "Evaluating '#{@message_event}' against '#{event}'"
        send_alert(policy) if event == @message_event
      end
    end

    private

    def send_alert(policy)
      @message_source      = policy['email']['source']
      @message_destination = policy['email']['destination']

      if @message_destination
        @logger.info "Sending alert to #{@message_destination}."
        ses.send_email email_options
      else
        @logger.info "Destination not set, no message sent."
      end
    end

    def email_options
      { :source      => @message_source,
        :destination => { :to_addresses => [ @message_destination ] },
        :message     => { :subject => {
                            :data => "Alert: #{@message_subject}"
                          },
                          :body    => {
                            :text => {
                              :data => @message_data
                            }
                          }
                        } 
      }
    end

    def process_message(message)
      begin
        message_body    = JSON.parse message
        message_details = JSON.parse message_body['Message']
      rescue JSON::ParserError => e
        @logger.error e.message
        return false
      end

      @message_cause       = message_details['Cause']
      @message_event       = message_details['Event']
      @message_description = message_details['Description']
      @message_subject     = message_body['Subject']
      @message_data        = "#{@name} received alert: \n\n #{@message_description} \n\n #{@message_cause}"

      true
    end

    def ses
      @ses ||= AwsAlertMonitor::AWS::SES.new
    end
  end
end
