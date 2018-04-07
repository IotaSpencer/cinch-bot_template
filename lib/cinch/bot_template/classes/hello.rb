require 'thor'
require 'highline'

require 'cinch/bot_template/templates/hello'
module Cinch
  module BotTemplate
    module Classes
      class Hello
        def initialize(directory:, options:)
          @hl        = HighLine.new($stdin, $stderr, 80)
          @opts      = Hash.new { |hash, key| hash[key] = {} }
          @directory = directory
          @options   = options
        end


        def get_001_bot_name
          @hl.say "What's the bot's name"
          @opts['bot']['nick'] = @hl.ask "    > ", String
        end

        # @note What the executable file will be named + .rb
        def get_002_bot_file
          @hl.say "What should the executable file be named."
          @hl.say "Use a hyphen by itself '-' to output to stdout "
          @hl.say "instead of a file."
          @hl.say "The generator will add .rb automatically."
          filename = @hl.ask "    > ", String
          if filename == '-'
            @opts['stdout'] = true
            return
          end
          @opts['bot']['file'] = filename.include?('.rb') ? filename : filename + '.rb'
        end


        def generate
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          tpl = Cinch::BotTemplate::Templates::Hello.new.generate(nick: @opts['bot']['nick'])
          Cinch::BotTemplate.show_wait_spinner(5) do
            if @opts.fetch('stdout', nil)
              puts tpl
            else
              filename = @opts.dig('bot', 'file')
              open filename, 'a+' do |fd|
                fd.puts tpl
              end
            end
          end
        end
      end
    end
  end
end