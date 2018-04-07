require 'thor'
require 'cinch/bot_template/main/thor'
require 'cinch/bot_template/main/desc'
require 'cinch/bot_template/main/plugin'
require 'cinch/bot_template/main/bot'
require 'cinch/bot_template/classes/hello'
require 'cinch/bot_template/main/config'

require 'cinch/bot_template/main/cli'
require 'cinch/bot_template/main/spinner'

module Cinch
  module BotTemplate
    module CLI
      class App < Thor
        class_option(:debug, type: :boolean, hide: true)

        map %w[--version -v] => :__print_version
        desc '--version, -v', 'Print the version'

        # Prints version string
        # @return [NilClass] nil
        def __print_version
          puts Cinch::BotTemplate::VERSION
        end

        desc 'gen [DIR] [options]', 'Generate a skeleton of a full bot'
        method_option 'multi-server', type: :boolean, default: false, aliases: %w(-m), required: false, hide: true

        long_desc Cinch::BotTemplate::Descs::Gen.Gen

        def gen(dir)
          generator = Cinch::BotTemplate::CLI::Base.new(dir, self.shell,options: options)
          generator.generate
        end

        desc 'hello', 'Creates a simple hello world bot in one file'
        long_desc Cinch::BotTemplate::Descs::Hello.Gen

        def hello
          generator = Cinch::BotTemplate::Classes::Hello.new
          generator.generate
        end

        desc 'plugin [command] [options]', 'Generate a plugin'
        subcommand('plugin', Cinch::BotTemplate::Plugin)

        desc 'bot [command] [options]', 'Generate a bot file'
        subcommand('bot', Cinch::BotTemplate::Bot)

        desc 'config [command] [options]', 'Generate a bot config'
        subcommand('config', Cinch::BotTemplate::Config)

      end
    end
  end
end