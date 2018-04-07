require 'cinch/bot_template/classes/plugin'
require 'thor'

module Cinch
  module BotTemplate
    class Plugin < Thor
      long_desc Cinch::BotTemplate::Descs::Plugin.Gen
      desc 'gen [options]', 'Generate a plugin'
      def gen(dir)
        generator = Cinch::BotTemplate::Classes::Plugin.new(directory: dir, options: options)
        generator.generate
      end
    end
  end
end