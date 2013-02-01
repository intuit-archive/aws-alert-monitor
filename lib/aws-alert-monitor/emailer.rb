module AwsAlertMonitor

  class Emailer

    def initialize(args)
      @body    = args['body']
      @emailer = args['emailer']
      @from    = args['from']
      @subject = args['subject']
      @to      = Array(args['to'])
    end

    def send_email
      emailer.send_email email_options
    end

    private
    def email_options
      {
        :source      => @from,
        :destination => { :to_addresses => @to },
        :message     => { :subject => { :data => @subject },
                          :body    => { :text => { :data => @body } } }
      }
    end

    def emailer
      @emailer ||= AwsAlertMonitor::AWS::SES.new
    end

  end

end
