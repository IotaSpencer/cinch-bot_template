require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      class Bot
        def generate(nick:)


          bot = <<~BOT
          
          $cfg = YAML.load_file(`echo ~/.gitall-rc.yml`.chomp!)
          $bots = Hash.new
          $threads = Array.new
          
          # For the sake of this example, we'll create an ORM-like model and give it an
          # authenticate method, that checks if a given password matches.
          class User < Struct.new :nickname, :password, :type
            def authenticate(pass)
              password == pass
            end
          end
          
          # Simulate a database.
          $users = []
          @users = YAML.load_file(`echo ~/.gitall-rc.yml`.chomp!)['users']
          @users.each do |user, hash|
            password = hash['password']
            role = hash['role']
            $users << User.new(user, password, role)
          end
          
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
                c.plugins.plugins << ChanControl
                c.plugins.options[ChanControl][:authentication_level] = :admins
                c.plugins.plugins << Admin
                c.plugins.options[Admin][:authentication_level] = :admins
                c.plugins.plugins << Cinch::Plugins::UserList
                c.plugins.options[Cinch::Plugins::UserList][:authentication_level] = :admins
              end
            end
            bot.loggers.clear
            bot.loggers << GitLogger.new(name, File.open("log/gitall-#{name}.log", "a"))
            bot.loggers << GitLogger.new(name, STDOUT)
            bot.loggers.level = :debug
            $bots[name] = bot
          end
          $bots.each do |key, bot|
            puts "Starting IRC connection for #{key}..."
            $threads << Thread.new { bot.start }
          end

          BOT

          bot
        end
      end
    end
  end
end