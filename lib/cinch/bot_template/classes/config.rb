require 'thor'
require 'highline'

require 'cinch/bot_template/templates/config'
module Cinch
  module BotTemplate
    module Classes
      class Config
        def initialize(options:, shell:, all: false)
          @hl        = HighLine.new($stdin, $stderr, 80)
          @opts      = Hash.new { |hash, key| hash[key] = {} }
          @options   = options
          @all       = all
          @shell     = shell

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

        def get_001_bot_networks
          if @options['multi-server']
            @hl.say "What networks? "
            nets     = {}
            networks = @hl.ask "> " do |q|
              q.gather = /#\$/
            end
            networks.each do |network|
              nets[network] = @hl.ask("Server for #{network}?")
            end
            @opts['bot']['networks'] = nets
          else
            @hl.say "Server "
            server                 = @hl.ask "> "
            @opts['bot']['server'] = server
          end

        end

        # @note The bot's nickname
        def get_002_bot_name
          @hl.say "What's the bot's main nickname"
          @opts['bot']['nick'] = @hl.ask "    > ", String
        end


        def generate(directory = Pathname('.'))
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          tpl = Cinch::BotTemplate::Templates::Config.new.generate(
              nick:     @opts.dig('bot', 'nick'),
              multi:    @options.dig('multi-server'),
              networks: @options.dig('multi-server') ? @opts.dig('bot', 'networks') : @opts.dig('bot', 'server')

          )
          if @opts.fetch('stdout', nil)
            puts tpl
          else
            filename = directory.join(@opts.dig('bot', 'nick')+'.yml')
            open filename, 'a+' do |fd|
              fd.puts tpl
            end
            filename
          end
        end
      end
    end
  end
end