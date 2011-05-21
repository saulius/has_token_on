$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'active_support/all'
require 'active_record'
require 'with_model'
require 'mocha'

require 'has_token_on'
require 'has_token_on/models/active_record'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.extend WithModel
end

