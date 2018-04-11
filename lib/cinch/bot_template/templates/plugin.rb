require 'fileutils'
require 'active_support/core_ext/string'
module Cinch
  module BotTemplate
    module Templates
      class Plugin
        def Plugin.generate(plugin_names:)
          plugins = {}
          plugin_names.each do |plugin|
            name = "#{plugin.capitalize}Plugin"

            bot = <<~BOT
            class #{name}
              include Cinch::Plugin
              match /^hello$/, method: :hello_world
              # @param [Cinch::Message] m cinch message object
              def hello_world(m)
                m.reply "Hello \#{m.user.nick}"
              end
            end
            BOT
            plugins[plugin+'.rb'] = bot

          end
          plugins
        end
      end
    end
  end
end