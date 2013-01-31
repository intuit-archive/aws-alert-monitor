module AwsAlertMonitor

  class EventClassifier

    def initialize(message)
      @message = message
    end

    def event
      event_subjects_classes.each do |subject, klass|
        return klass.new(@message) if generic_event_subject =~ subject
      end
      # TODO add unknown event type
      return nil
    end

    private
    def event_subjects_classes
      {
        /\AAuto Scaling: / => AwsAlertMonitor::Events::AutoScalingNotification,
        /\AALARM: /        => AwsAlertMonitor::Events::CloudWatchAlarm
      }
    end

    def generic_event_subject
      AwsAlertMonitor::Event.new(@message).subject
    end

  end

end
