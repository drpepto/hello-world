require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end
