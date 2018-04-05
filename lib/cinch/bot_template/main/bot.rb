require  'thor'
module Cinch
  module BotTemplate

    class Bot < Thor
      desc 'gen [options]', 'Generate the executable for a bot'
      # @param [String] filename Name of the plugin
      def gen(filename, bot_name)
        generator = Cinch::BotTemplate::Classes::Bot.new
        generator.generate
      end
    end
  end
end