module AwsAlertMonitor
  class Config

    attr_accessor :access_key, :secret_key

    def initialize(args={})
      @opts       = args[:opts] ||= Hash.new
      @config     = load_config_file
      load_config
    end

    def load_config
      self.access_key = @opts.fetch :aws_access_key, @config['access_key']
      self.secret_key = @opts.fetch :aws_secret_key, @config['secret_key']
    end

    private

    def load_config_file
      config_file = "#{ENV['HOME']}/.monitor.yml"

      if File.exists? config_file
        YAML::load File.open config_file
      else
        { }
      end
    end

  end
end
