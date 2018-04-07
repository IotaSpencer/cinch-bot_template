require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      class Config
        def generate(config_path:, nick:)


          multi_server = <<~BOT
          ---
          bot:
            networks:
              ovd:
                server: irc.overdrivenetworks.com
                port: 6697
                use_ssl: true
                use_ssl_verify: false
                mps: 3.0
                nickname: GitAll
                username: GitAll
                realname: https://gitlab.com/gitall/gitall
                identify-with: sasl
                cert: "/home/bots/.gitall-cert/certfp.pem"
                sasl:
                  username: gitall
                  password: 8PECxmCMcCviTKhDSrHN
                channels:
                - "#dev"
                - "#gitall"
              buddy:
                server: irc.buddy.im
                port: 6697
                use_ssl: true
                use_ssl_verify: false
                mps: 3.0
                nickname: GitHooks
                username: Git
                realname: https://gitlab.com/gitall/gitall
                identify-with: sasl
                sasl:
                  username: gitall
                  password: 8PECxmCMcCviTKhDSrHN
                channels:
                - "#DNSBLim-Staff"
                - "#IRC-Source/Dev/Priv"
              fn:
                server: chat.freenode.net
                port: 6697
                use_ssl: true
                use_ssl_verify: false
                mps: 3.0
                nickname: gitall
                username: gitall
                realname: https://gitlab.com/gitall/gitall
                identify-with: sasl
                sasl:
                  username: gitall-bot
                  password: 8PECxmCMcCviTKhDSrHN
                channels:
                - "#gitall-dev"
                - "#gitall"
          BOT
          single_server = <<~BOT
          
          $cfg = YAML.load_file(`echo ~/.gitall-rc.yml`.chomp!)
          $bots = Hash.new
          $threads = Array.new

          
          $cfg['networks'].each do |name, ncfg|
            bot = Cinch::Bot.new do
              configure do |c|
                c.server = ncfg.fetch('server')
                c.port = ncfg.fetch('port')
                c.nick = ncfg.fetch('nickname')
                c.user = ncfg.fetch('username')
                c.realname = ncfg.fetch('realname')
                c.plugins.plugins << Cinch::Plugins::Identify
                identify_with = ncfg.fetch('identify-with')
                case identify_with
                when 'nickserv'
                  begin
                    c.plugins.options[Cinch::Plugins::Identify] = {
                      :username => ncfg.fetch('sasl-username'),
                      :password => ncfg.fetch('sasl-password'),
                      :type     => :nickserv,
                    }
                  rescue KeyError
                  end
                when 'sasl'
                  begin
                    c.sasl.username = ncfg.fetch('sasl-username')
                    c.sasl.password = ncfg.fetch('sasl-password')
                  rescue KeyError
                  end
                when 'cert'
                  begin
                    c.ssl.client_cert = ncfg.fetch('certfp')
                  rescue KeyError
                  end
                end
                c.channels = ncfg.fetch('channels')
                c.ssl.use = ncfg.fetch('ssl')
                c.ssl.verify = ncfg.fetch('sslverify')
                c.messages_per_second = ncfg.fetch('mps')
          
                # Global configuration. This means that all plugins / matchers that
                # implement authentication make use of the :login strategy, with a user
                # level of :users.
                c.authentication          = Cinch::Configuration::Authentication.new
                c.authentication.strategy = :login
                c.authentication.level    = :users
          
                # The UserLogin plugin will call this lambda when a user runs !register.
                c.authentication.registration = lambda { |nickname, password|
                  # If you were using an ORM, you'd do something like
                  # `User.create(:nickname => nickname, :password => password)` here.
                  return false if $users.one? { |user| user.nickname == nickname }
                  $users << User.new(nickname, password, 'user')
                }
          
                # The UserLogin plugin will call this lambda when a user runs !login. Note:
                # the class it returns must respond to #authenticate with 1 argument (the
                # password the user tries to login with).
                c.authentication.fetch_user = lambda { |nickname|
                  # If you were using an ORM, you'd probably do something like
                  # `User.first(:nickname => nickname)` here.
                  $users.find { |user| user.nickname == nickname }
                }
          
                # The Authentication mixin will call these lambdas to check if a user is
                # allowed to run a command.
                c.authentication.users  = lambda { |user| user.type == 'user' }
                c.authentication.admins = lambda { |user| user.type == 'admin' }
                c.plugins.plugins << Cinch::Plugins::UserLogin
                c.plugins.plugins << Cinch::Plugins::BasicCTCP
                c.plugins.options[Cinch::Plugins::BasicCTCP][:replies] = {
                    version: Version::Bot.version,
                    source:  'https://gitlab.com/gitall/gitall'
                }

              end
            end
            bot.loggers.level = :debug
            $bots[name] = bot
          end
          $bots.each do |key, bot|
            puts "Starting IRC connection for \#{key}..."
            $threads << Thread.new { bot.start }
          end

          BOT

          bots = {
              single: single_server,
              multi: multi_server
          }
        end
      end
    end
  end
end