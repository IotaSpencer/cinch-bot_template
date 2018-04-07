require 'paint'
class Thor
  class << self
    def command_help(shell, command_name)
      meth    = normalize_command_name(command_name)
      command = all_commands[meth]
      handle_no_command_error(meth) unless command

      shell.say "USAGE ", ['white', :bold]
      shell.say "\b:"
      shell.say "  #{banner(command)}"
      class_options_help(shell, nil => command.options.values)
      if command.long_description
        shell.say "DESCRIPTION ", ['white', :bold]
        shell.say "\b:"
        shell.print_wrapped(command.long_description)
      else
        shell.say command.description
      end
    end

    alias_method :task_help, :command_help
  end
  module Base
    module ClassMethods
      def print_options(shell, options, group_name = nil)
        return if options.empty?

        list    = []
        padding = options.map { |o| o.aliases.size }.max.to_i * 4

        options.each do |option|
          next if option.hide
          item = [option.usage(padding)]
          item.push(option.description ? "# #{option.description}" : "")

          list << item
          list << ["", "# Default: #{option.default}"] if option.show_default?
          list << ["", "# Possible values: #{option.enum.join(', ')}"] if option.enum
        end

        shell.say(group_name ? "#{group_name} options:" : "Options:") unless list.empty?
        shell.print_table(list, :indent => 2) unless list.empty?
        #shell.say ""
      end
    end

  end
  module Shell
    class Basic
      def prepare_message(message, *color, paint: true)
        case paint
        when true
          spaces = "  " * padding
          spaces + Paint[message.to_s, *color]
        when false
          spaces = "  " * padding
          spaces + set_color(message.to_s, *color)
        else
          spaces = "  " * padding
          spaces + Paint[message.to_s, *color]
        end

      end

      # Say (print) something to the user. If the sentence ends with a whitespace
      # or tab character, a new line is not appended (print + flush). Otherwise
      # are passed straight to puts (behavior got from Highline).
      #
      # ==== Example
      # say("I know you knew that.")
      #
      def say(message = "", color = nil, force_new_line = (message.to_s !~ /( |\t)\Z/), paint: true)
        buffer = prepare_message(message, *color, paint: paint)
        buffer << "\n" if force_new_line && !message.to_s.end_with?("\n")

        stdout.print(buffer)
        stdout.flush
      end

      # @note Override Thor::Shell::Basic.print_wrapped
      # @overload Thor::Shell::Basic.print_wrapped
      #   1. Replace 6 - with 6 spaces
      #   2. Replace 4 - with 4 spaces
      #   3. Replace 2 - with 2 spaces
      #   4. Replace #$ at the beginning of lines
      #     with '\n'
      def print_wrapped(message, options = {})
        message.lstrip!
        message.gsub!(/\n\s+/, "\n")
        message = message.split("\n")
        message.each do |line|
          line.gsub!(/^------/, ' ' * 6) if line[0..5] == '-' * 6
          line.gsub!(/^----/, ' ' * 4) if line[0..3] == '-' * 4
          line.gsub!(/^--/, ' ' * 2) if line[0..1] == '-' * 2
          line.gsub!(/^#\$/, "\n")
          stdout.puts line
        end
      end
    end
  end
end