module AwsAlertMonitor

  class EventClassifier

    def initialize(message)
      @message = message
    end

    def event
      event_subjects_classes.each do |subject, klass|
        return klass.new(@message) if generic_event_subject =~ subject
      end

      unknown_event_class.new @message
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

    def unknown_event_class
      AwsAlertMonitor::Events::Unknown
    end

  end

end
