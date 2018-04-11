require 'thor'
require 'highline'

require 'cinch/bot_template/templates/plugin'
module Cinch
  module BotTemplate
    module Classes
      class Plugin
        def initialize(directory: Pathname('.').to_s, shell:, options:, all: false)
          @hl        = HighLine.new($stdin, $stderr, 80)
          @opts      = Hash.new { |hash, key| hash[key] = {} }
          @all       = all
          @shell = shell
          @directory = directory
          @options   = options
        end

        # @param [String] file_path File path to config as string to parse
        def parse_config_path(file_path)
          path = Pathname(file_path)
          path = File.expand_path(path)
          path.to_s
        end

        def get_001_plugin_names
          @hl.say "What's the plugin name(s)?"
          @hl.say "Each name you put here will have 'Plugin' appended to it."
          @hl.say "Each name will become a separate plugin file"
          @opts['plugin_names'] = @hl.ask "    > ", -> (str) { str.split(' ') }
        end


        def generate(directory:)
          meths = self.methods.select { |x| x =~ /^get_[0-9]+_.*/ }
          meths.sort! { |m, n| m.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i <=> n.to_s.gsub(/^get_([0-9]+)_.*/, '\1').to_i }
          meths.each do |m|
            self.send(m)
          end
          @hl.say "Generating..."
          plugins = Cinch::BotTemplate::Templates::Plugin.generate(plugin_names: @opts['plugin_names'])
          FileUtils.mkpath(directory.join('plugins'))
          plugins.each do |plugin, text|
            open Pathname(directory).join('plugins', plugin), 'w' do |fd|
              fd.puts text
            end
          end
        end
      end
    end
  end
end