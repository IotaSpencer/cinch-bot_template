require 'thor'
module Cinch
  module BotTemplate
    class Plugin < Thor
      desc 'gen [options]', 'Generate a plugin'
      # @param [String] plugin_name Name of the plugin
      def gen(plugin_name)
        @plugin_name = plugin_name
      end
    end
  end
end