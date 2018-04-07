require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      class Config
        def generate(nick:, multi:, networks:)

          if multi
            head = "bot:\n  networks:\n"
            body = []
            networks.each do |network, server|
              body <<
<<-BODY
    #{network}:
      server: #{server}
      port: 6697
      use_ssl: true
      use_ssl_verify: false
      mps: 3.0
      nickname: #{nick}
      username: #{nick}
      realname: #{nick}
      identify-with: sasl
      #cert: "/path/to/cert"
      sasl:
        username: #{nick}
        password: PASSWORD
      channels:
      - "#chat"
BODY
            end
            head + body.join

          else
<<-BOT
bot:
  server: #{networks}
  port: 6697
  use_ssl: true
  use_ssl_verify: false
  mps: 3.0
  nickname: #{nick}
  username: #{nick}
  realname: #{nick}
  identify-with: sasl
  #cert: "/path/to/cert"
  sasl:
    username: #{nick}
    password: PASSWORD
  channels:
  - "#chat"
BOT
          end
        end
      end
    end
  end
end