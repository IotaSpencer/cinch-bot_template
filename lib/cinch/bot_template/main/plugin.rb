require 'cinch/bot_template/classes/plugin'
require 'thor'

module Cinch
  module BotTemplate
    class Plugin < Thor
      desc 'gen [options]', 'Generate a plugin'
      # @param [String] plugin_name Name of the plugin
      def gen
        generator = Cinch::BotTemplate::Classes::Plugin.new
        generator.generate
      end
    end
  end
end