ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
require 'bundler/setup' # Set up gems listed in the Gemfile.

require 'telegram/bot'
require 'active_record'


# Libs
require './lib/database_connector'
require './lib/app_configurator'
require './lib/message_responder'

require './config/initializers/dotenv'
require './config/initializers/configure'

# Models
require './models/user'
require './models/game'
require './models/game_result'
require './models/board'
require './models/player'
require './models/telegram_board'




require 'byebug'






