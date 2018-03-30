require 'thor'
module Cinch
  module BotTemplate
    class CLI < Thor

      map %w[--version -v] => :__print_version
      desc '--version, -v', 'Print the version'

      # Prints version string
      # @return [NilClass] nil
      def __print_version
        puts Cinch::BotTemplate::VERSION
      end

      def gen(filename)

      end
    end
  end
end