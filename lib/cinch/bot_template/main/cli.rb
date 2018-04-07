require 'thor'
require 'highline'
require 'cinch/bot_template/classes/bot'
require 'cinch/bot_template/classes/plugin'
require 'cinch/bot_template/classes/config'
module Cinch
  module BotTemplate
    module CLI
      class Base
        def initialize(directory, options)
          @hl = HighLine.new($stdin, $stderr, 80)
          @opts = Hash.new{ |hash, key| hash[key] = {} }
          @options = options
          @directory = directory
        end

        def generate
          bot = Cinch::BotTemplate::Classes::Bot.new(directory: @directory, options: @options, all: true)
          bot.generate

          config = Cinch::BotTemplate::Classes::Config.new(directory: @directory, options: @options, all: true)
          config.generate
        end
      end
    end
  end
end