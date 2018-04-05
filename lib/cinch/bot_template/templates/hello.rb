require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      class Hello
        def generate(nick:)


          hello = <<~HELLO
          require 'cinch'

          bot = Cinch::Bot.new do
            configure do |c|
              c.server = "irc.electrocode.net"
              c.channels = ["#bots"]
              c.nick = '#{nick}'
            end

            on :message, "hello" do |m|
              m.reply "Hello, \#{m.user.nick}"
            end
          end

          bot.start
          HELLO

          hello
        end
      end
    end
  end
end