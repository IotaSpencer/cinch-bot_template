require 'fileutils'
module Cinch
  module BotTemplate
    module Templates
      class Bot


        def generate(multi:, config_file:)
          cfg = config_file
          if multi
            bot = <<~BOT
              #! /usr/bin/env ruby
              require 'cinch'
              require 'yaml'
              require 'cinch/plugins/identify'
              require 'cinch/plugins/basic_ctcp'

              $cfg = YAML.load_file("#{cfg}")
              $bots = Hash.new
              $threads = Array.new
              
              $cfg['bot']['networks'].each do |name, ncfg|
                bot = Cinch::Bot.new do
                  configure do |c|
                    c.server = ncfg.dig('server')
                    c.port = ncfg.dig('port')
                    c.nick = ncfg.dig('nickname')
                    c.user = ncfg.dig('username')
                    c.realname = ncfg.dig('realname')
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
              
                    c.plugins.plugins << Cinch::Plugins::BasicCTCP
                    c.plugins.options[Cinch::Plugins::BasicCTCP][:replies] = {
                        version: Bot.version
                    }
                  end
                end
                bot.loggers.clear

                bot.loggers.level = :debug
                $bots[name] = bot
              end
              $bots.each do |key, bot|
                puts "Starting IRC connection for \#{key}..."
                $threads << Thread.new { bot.start }
              end
              
              class Bot
                def Bot.version
                  $cfg['bot']['version']
                end
              end

            BOT

            bot
          else
            bot = <<~BOT
              #! /usr/bin/env ruby
              require 'cinch'
              require 'yaml'
              require 'cinch/plugins/identify'
              require 'cinch/plugins/basic_ctcp'

              $cfg = YAML.load_file("#{cfg}")
              $threads = Array.new
            
              bot = Cinch::Bot.new do
                configure do |c|
                  c.server = $cfg.dig('bot', 'server')
                  c.port = $cfg.dig('bot', 'port')
                  c.nick = $cfg.dig('bot', 'nickname')
                  c.user = $cfg.dig('bot', 'username')
                  c.realname = $cfg.dig('bot', 'realname')
                  c.plugins.plugins << Cinch::Plugins::Identify
                  identify_with = $cfg.dig('bot', 'identify-with')
                  case identify_with
                  when 'nickserv'
                    begin
                      c.plugins.options[Cinch::Plugins::Identify] = {
                        :username => $cfg.dig('bot', 'sasl', 'username'),
                        :password => $cfg.fetch('bot','sasl', 'password'),
                        :type     => :nickserv,
                      }
                    rescue KeyError
                    end
                  when 'sasl'
                    begin
                      c.sasl.username = $cfg.dig('bot', 'sasl', 'username')
                      c.sasl.password = $cfg.dig('bot', 'sasl', 'password')
                    rescue KeyError
                    end
                  when 'cert'
                    begin
                      c.ssl.client_cert = $cfg.dig('bot', 'cert')
                    rescue KeyError
                    end
                  end
                  c.channels = $cfg.dig('bot', 'channels')
                  c.ssl.use = $cfg.dig('bot', 'use_ssl')
                  c.ssl.verify = $cfg.dig('bot', 'use_ssl_verify')
                  c.messages_per_second = $cfg.dig('bot', 'mps')
            
                  c.plugins.plugins << Cinch::Plugins::BasicCTCP
                  c.plugins.options[Cinch::Plugins::BasicCTCP][:replies] = {
                      version: Bot.version,
                  }

                  # Add more plugins here.
                end
                bot.loggers.clear

                bot.loggers.level = :debug
              end
              $threads << Thread.new { bot.start }
              
              class Bot
                def Bot.version
                  $cfg['bot']['version']
                end
              end
            BOT

            bot
          end
        end
      end
    end
  end
end