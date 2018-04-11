require 'thor'
require 'highline'

require 'cinch/bot_template/templates/bot'
module Cinch
  module BotTemplate
    module Classes
      class Bot
        def initialize(options:, shell:, all: false)
          @hl        = HighLine.new($stdin, $stderr, 80)
          @opts      = Hash.new { |hash, key| hash[key] = {} }
          @options   = options
          @all       = all
          @shell     = shell

        end

        # @note What the executable file will be named + .rb
        def get_001_bot_file
          @hl.say "What should the executable file be named."
          unless @all
            @hl.say "Use a hyphen by itself '-' to output to stdout "
            @hl.say "instead of a file."
          end

          @hl.say "The generator will add .rb automatically."
          filename = @hl.ask "    > ", String
          if filename == '-'
            @opts['stdout'] = true
            return
          end
          @opts['bot']['file'] = filename.include?('.rb') ? filename : filename + '.rb'
        end
        def get_002_config_file
          @shell.say "Grabbing config path from state..."
          @opts['config_path'] = Pathname(@directory).join(@config_file)
        end

        # @param [Pathname] directory Bot directory
        # @param [Pathname] config_file configuration path
        def generate(directory:, config_file:)
          @directory = directory
          @config_file = config_file
          if @options.fetch(:debug, nil)
            at_exit do
              puts @options
              puts @opts
            end
          end
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          tpl = Cinch::BotTemplate::Templates::Bot.new.generate(
              multi:       @options['multi-server'],
              config_file: @config_file,
              )
          if @opts.fetch('stdout', nil)
            puts tpl
          else
            filename = Pathname(directory).join(@opts.dig('bot', 'file'))
            open filename, 'a+' do |fd|
              fd.puts tpl
            end
          end
        end
      end
    end
  end
end