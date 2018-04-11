require 'cinch/bot_template/classes/bot'
require 'cinch/bot_template/main/desc'
require  'thor'

module Cinch
  module BotTemplate

    class Config < Thor

      desc 'gen [options]', 'Generate the executable for a bot'
      method_option 'multi-server', type: :boolean, default: false, aliases: %w(-m), required: false, hide: true

      long_desc Cinch::BotTemplate::Descs::Plugin.Gen
      def gen(dir)
        generator = Cinch::BotTemplate::Classes::Config.new(options: options, shell: self.shell)
        generator.generate(Pathname(dir))
      end
    end
  end
end