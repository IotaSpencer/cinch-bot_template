module Cinch
  module BotTemplate
    module Descs
      module Bot
        def self.Gen
          <<~GEN
          '#{Pathname($PROGRAM_NAME).basename} bot gen' will generate a bot file,
          a executable file that has the basics of a cinch bot inside.
          \#$
          If you're looking to generate a whole bot, config, plugins,
          bot file, logs, then use '#{Pathname($PROGRAM_NAME).basename} gen' itself.
          \#$
          See the help on '#{Pathname($PROGRAM_NAME).basename} help gen'
          for information on using having a bot connect to
          multiple servers/networks.

          GEN
        end
      end
    end
  end
end