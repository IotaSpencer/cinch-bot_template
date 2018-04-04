require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      module Hello
        module_function

        def generate(*args)

          <<-HELLO
          require 'cinch'

          bot = Cinch::Bot.new do
            configure do |c|
              c.server = "irc.freenode.org"
              c.channels = ["#cinch-bots"]
            end

            on :message, "hello" do |m|
              m.reply "Hello, #{m.user.nick}"
            end
          end

          bot.start
          HELLO
        end
      end
    end
  end
end