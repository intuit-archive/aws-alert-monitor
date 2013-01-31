module AwsAlertMonitor

  class EventClassifier

    def initialize(message)
      @message = message
    end

    def event
      event_subjects_classes.each do |subject, klass|
        return klass.new(@message) if generic_event_subject =~ subject
      end
    end

    private
    def event_subjects_classes
      {
        /\AAuto Scaling: / => AwsAlertMonitor::Events::AutoScalingNotification
      }
    end

    def generic_event_subject
      AwsAlertMonitor::Event.new(@message).subject
    end

  end

end
