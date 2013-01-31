module AwsAlertMonitor

  class Event

    attr_reader :message_data
    attr_reader :raw_data

    def initialize(message)
      @raw_data     = JSON.parse(message)
      @message_data = JSON.parse(@raw_data['Message'])
    end

    def body
      raise NotImplementedError
    end

    def subject
      raise NotImplementedError
    end

    def type
      raise NotImplementedError
    end

  end

end
