require 'thor'
require 'highline'
module Cinch
  module BotTemplate
    module CLI
      class Base
        def initialize
          @hl = HighLine.new($stdin, $stderr, 80)
          @opts = Hash.new{ |hash, key| hash[key] = {} }

        end


        def get_001_bot_name
          @hl.say "What's the bot's name"
          @opts['bot']['name'] = @hl.ask "    > ", String
        end
        # @note What the executable file will be named + .rb
        def get_002_bot_file
          @hl.say "What should the executable file be named."
          @hl.say "The generator will add .rb automatically."
          filename = @hl.ask "    > ", String

          @opts['bot']['file'] = filename.include?('.rb') ? filename : filename + '.rb'
        end
        # @note Whether the bot will be multi-server/multi-network
        # @overload :get_003_bot_multi_server
        #   This makes the generator use more threads to make a bot instance
        #   connect to multiple networks.
        def get_003_bot_multi_server
          @hl.say "Do you want the bot to be multi-server"
          @opts['bot']['multi-server'] = @hl.agree "    > ", true
        end

        def generate
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating... "
          puts @opts.inspect
          Cinch::BotTemplate.show_wait_spinner(10) do

          end
        end
      end
    end
  end
end