require 'cinch/bot_template/classes/bot'
require 'cinch/bot_template/main/desc'
require  'thor'

module Cinch
  module BotTemplate

    class Config < Thor
      desc 'gen [options]', 'Generate the executable for a bot'

      long_desc Cinch::BotTemplate::Descs::Plugin.Gen
      def gen
        generator = Cinch::BotTemplate::Classes::Config.new(directory: directory, options: options)
        generator.generate
      end
    end
  end
end