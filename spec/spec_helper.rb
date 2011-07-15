require 'rspec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/squirrel.rb")

RSpec.configure do |config|
  config.mock_with :rspec
end

def em(&block)
  EM.run do
    block.call
    EM.stop
  end
end