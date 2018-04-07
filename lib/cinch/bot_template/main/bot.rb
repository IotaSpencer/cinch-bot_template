require 'cinch/bot_template/classes/bot'
require 'cinch/bot_template/main/desc'
require 'thor'

module Cinch
  module BotTemplate

    class Bot < Thor

      method_option 'multi-server', type: :boolean, default: false, aliases: %w(-m), hide: true
      long_desc Descs::Bot.Gen
      desc 'gen [options]', 'Generate the executable for a bot'
      def gen
        generator = Cinch::BotTemplate::Classes::Bot.new(options)
        generator.generate
      end
    end
  end
end