module AwsAlertMonitor

  class Event

    attr_reader :message_data
    attr_reader :raw_data

    def initialize(message)
      @raw_data     = JSON.parse(message)
      @message_data = determine_message_data
    end

    def body
      raise NotImplementedError
    end

    def subject
      @raw_data['Subject']
    end

    def type
      raise NotImplementedError
    end

    private
    def determine_message_data
      JSON.parse(@raw_data.fetch('Message', '{}'))
    end

  end

end
