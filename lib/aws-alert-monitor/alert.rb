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

      unless process_message
        @logger.error "Unable to process message."
        return false
      end

      @events.each_pair do |event, policy|
        @logger.info "Evaluating '#{@message_event}' against '#{event}'"
        send_alert(policy) if event == @message_event
      end if @events
    end

    private

    def send_alert(policy)
      @message_source      = policy['email']['source']
      @message_destination = policy['email']['destination']

      if @message_destination
        @logger.info "Sending alert to #{@message_destination}."
        send_email
      else
        @logger.info "Destination not set, no message sent."
      end
    end

    def email_options
      {
        'body'    => @message_data,
        'from'    => @message_source,
        'subject' => @message_subject,
        'to'      => Array(@message_destination)
      }
    end

    def event_classifier
      AwsAlertMonitor::EventClassifier.new @message
    end

    def process_message
      begin
        event = event_classifier.event
      rescue JSON::ParserError => e
        @logger.error e.message
        return false
      end

      @message_event   = event.type
      @message_subject = event.subject
      @message_data    = "#{@name} #{event.body}"

      true
    end

    def send_email
      AwsAlertMonitor::Emailer.new(email_options).send_email
    end

  end
end
