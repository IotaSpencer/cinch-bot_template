require 'thor'
require 'cinch/bot_template/main/plugin'
require 'cinch/bot_template/main/bot'
require 'cinch/bot_template/main/hello'
require 'cinch/bot_template/main/cli'
require 'cinch/bot_template/main/spinner'
module Cinch
  module BotTemplate
    module CLI
      class App < Thor

        map %w[--version -v] => :__print_version
        desc '--version, -v', 'Print the version'

        # Prints version string
        # @return [NilClass] nil
        def __print_version
          puts Cinch::BotTemplate::VERSION
        end

        desc 'gen [options]', 'Generate a skeleton of a full bot'
        def gen
          generator = Cinch::BotTemplate::CLI::Base.new
          generator.generate
        end

        desc 'hello', 'Creates a simple hello world bot in one file'
        def hello
          generator = Cinch::BotTemplate::CLI::Hello.new
          generator.generate
        end

        desc 'plugin [command] [options]', 'Generate a plugin'
        subcommand('plugin', Cinch::BotTemplate::Plugin)

        desc 'bot [command] [options]', 'Generate a bot file'
        subcommand('bot', Cinch::BotTemplate::Bot)

      end
    end
  end
end