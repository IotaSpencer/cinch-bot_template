require 'thor'
require 'highline'
require 'cinch/bot_template/classes/gen_init'
require 'cinch/bot_template/classes/bot'
require 'cinch/bot_template/classes/plugin'
require 'cinch/bot_template/classes/config'
module Cinch
  module BotTemplate
    module CLI
      class Base
        def initialize(shell:, options:)
          @hl      = HighLine.new($stdin, $stderr, 80)
          @opts    = Hash.new { |hash, key| hash[key] = {} }
          @options = options
          @shell   = shell
        end

        def generate
          init = Cinch::BotTemplate::Classes::Init.new(
              options: @options,
              shell:   @shell,
              all:     true
          )
          init.generate
          directory = init.directory

          config = Cinch::BotTemplate::Classes::Config.new(
              options: @options,
              shell:   @shell,
              all:     true
          )
          cfg_path = config.generate(directory)

          bot = Cinch::BotTemplate::Classes::Bot.new(
              options: @options,
              shell:   @shell,
              all:     true
          )
          bot.generate(directory: directory, config_file: cfg_path)

          plugins = Cinch::BotTemplate::Classes::Plugin.new(
              shell: @shell,
              options: @options,
              all:     true
          )
          plugins.generate(directory: directory)
        end
      end
    end
  end
end