require 'rubygems'
require 'bundler/setup'

require 'aws-alert-monitor'
Dir[File.expand_path(File.join(File.dirname(__FILE__),'helpers', '*.rb'))].each do |f|
  require f
end

RSpec.configure do |config|
  #spec config
  config.include Fixtures
end
