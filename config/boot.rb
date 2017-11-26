ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'telegram/bot'
require 'active_record'

# Libs
Dir[File.join(__dir__, 'lib', '*.rb')].each {|file| require file }

# Initializers
Dir[File.join(__dir__, 'config', 'initializers', '*.rb')].each {|file| require file }

# Models
Dir[File.join(__dir__, 'models', '*.rb')].each {|file| require file }







