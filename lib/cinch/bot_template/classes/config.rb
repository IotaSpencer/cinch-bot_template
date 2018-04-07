require 'thor'
require 'highline'

require 'cinch/bot_template/templates/bot'
module Cinch
  module BotTemplate
    module Classes
      class Config
        def initialize(directory:, options:, all: false)
          @hl      = HighLine.new($stdin, $stderr, 80)
          @opts    = Hash.new { |hash, key| hash[key] = {} }
          @options = options
          @all     = all

        end

        # @param [String] file_path File path to config as string to parse
        def parse_config_path(file_path)
          begin
            path = Pathname(file_path)
            path = File.expand_path(path)
            path.to_s
          rescue
            at_exit do
              puts "Could not parse config path. Exiting.."
            end

            exit 1
          end

        end
        # @note The bot's nickname
        def get_001_bot_name
          @hl.say "What's the bot's name"
          @opts['bot']['nick'] = @hl.ask "    > ", String
        end


        def generate
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          tpl = Cinch::BotTemplate::Templates::Bot.new.generate(multi: @options, config_path: @opts['config_path'])
          if @opts.fetch('stdout', nil)
            puts tpl
          else
            filename = @opts.dig('config_path')
            open filename, 'a+' do |fd|
              fd.puts tpl
            end
          end
        end
      end
    end
  end
end