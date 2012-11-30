require 'json'

module AwsAlertMonitor
  class Alert

    def initialize(args)
      @config = args[:config]
      @logger = @config.logger
    end

    def process(body)
      message_body = JSON.parse(body)
      message = JSON.parse message_body['Message']

      source          = 'brett_weaver@intuit.com'
      destination     = 'brett_weaver@intuit.com'
      message_subject = 'this is atest'

      p message['Service']
      p message['Event']
      p message['Cause']
      p message['Description']
      p message['AutoScalingGroupName']

      options = { :source      => source,
                  :destination => { :to_addresses => [ destination ] },
                  :message     => { :subject => {
                                      :data => message_subject
                                    },
                                    :body    => {
                                      :text => {
                                        :data => message_body
                                      }
                                    }
                                  } 
                 }

      ses.send_email options
    end

    private

    def ses
      @ses ||= AwsAlertMonitor::AWS::SES.new :config => @config
    end
  end
end
