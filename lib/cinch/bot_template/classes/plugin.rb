require 'thor'
require 'highline'

require 'cinch/bot_template/templates/plugin'
module Cinch
  module BotTemplate
    module Classes
      class Plugin
        def initialize
          @hl = HighLine.new($stdin, $stderr, 80)
          @opts = Hash.new{ |hash, key| hash[key] = {} }

        end


        def get_001_plugin_name
          @hl.say "What's the plugin name?"
          @opts['plugin_name'] = @hl.ask "    > ", String
        end
        # @note What the executable file will be named + .rb
        def get_002_plugin_file
          @hl.say "What should the plugin file be named."
          @hl.say "Use a hyphen by itself '-' to output to stdout "
          @hl.say "instead of a file."
          @hl.say "The generator will add .rb automatically."
          filename = @hl.ask "    > ", String
          if filename == '-'
            @opts['stdout'] = true
            return
          end
          @opts['plugin_file'] = filename.include?('.rb') ? filename : filename + '.rb'
        end


        def generate
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          tpl = Cinch::BotTemplate::Templates::Plugin.new.generate(plugin_name: @opts['plugin_name'])
          Cinch::BotTemplate.show_wait_spinner(5) do
            if @opts.fetch('stdout', nil)
              puts tpl
            else
              filename = @opts.dig('plugin_file')
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