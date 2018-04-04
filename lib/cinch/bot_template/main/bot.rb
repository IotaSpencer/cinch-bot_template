require  'thor'
module Cinch
  module BotTemplate

    class Bot < Thor
      desc 'gen [options]', 'Generate the executable for a bot'
      # @param [String] filename Name of the plugin
      def gen(filename, bot_name)
        @plugin_name = filename
        @bot_name = bot_name
      end
    end
  end
end