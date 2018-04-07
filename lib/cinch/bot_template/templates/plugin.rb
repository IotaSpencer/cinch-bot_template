require 'fileutils'
require 'active_support/core_ext/string'
module Cinch
  module BotTemplate
    module Templates
      class Plugin
        def generate(plugin_name:)


          bot = <<~BOT
          
          class #{plugin_name.camelize}Plugin
            include Cinch::Plugin

            match /^hello$/, method: :hello_world

            def hello_world(m)
              m.reply "Hello \#{m.user.nick}"
            end
          end

          BOT

          bot
        end
      end
    end
  end
end