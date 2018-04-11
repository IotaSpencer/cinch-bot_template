require 'paint'
require 'pathname'
module Cinch
  module BotTemplate
    module Classes
      class Init
        attr :directory

        def initialize(options:, shell:, all:)
          @hl      = HighLine.new($stdin, $stderr, 80)
          @opts    = Hash.new { |hash, key| hash[key] = {} }
          @options = options
          @all     = all
          @shell   = shell
        end

        # @note There's more a format on return of [parsed,input]
        # @overload check_path
        #   Success => [parsed,input]
        #   Error   => [parsed,input,error]
        #   Error+  => [parsed,input,error,varstring,varstring,varstring]
        # @param [String] path Check path for existence.
        # @return [Array<Boolean,String>] if there was an error
        # @return [Array<String>] path if successful
        def check_path(path)
          current_dir   = Pathname('.').expand_path.realdirpath
          home_dir      = Pathname('~').expand_path.realdirpath
          path_string   = path
          path_instance = Pathname(path)
          path_full     = Pathname(path).expand_path.realdirpath

          if current_dir == home_dir and path_full == home_dir or path_string == '~'
            abort Paint['Error', 'red', :bold] + ': Will not create files in user home, use a subdirectory'
          else
            [path_full, path]

          end

        end

        def generate
          @shell.say "What path should be used to house the bot?"
          @shell.say "If directories don't exist, they will be created."
          @shell.say "'~' and '.' are available for compactness"
          @shell.say "However '~' is disallowed when using it by itself"
          @shell.say "This is so you don't put a bot directly in your home directory."
          @shell.say "ex: '~/bots/cinchfolder', '.' or './cinchfolder'"
          path = @shell.ask("What directory?")

          path_response = self.check_path(path)
          if path_response.length == 2 # Success
            parsed = path_response.first
            if parsed.exist?
              @directory = parsed
            else
              @directory = parsed
              FileUtils.mkpath(@directory.to_s)

            end

          elsif path_response.length == 3 # Error

          elsif path_response.length > 3 # Error+
          end
        end
      end
    end
  end
end