module Cinch
  module BotTemplate
    module Descs
      module Hello
        module_function

        def Gen
          <<~GEN
            '#{Pathname($PROGRAM_NAME).basename} hello' generates a simple one file
            --that allows you to start a bot up in seconds.
          GEN
        end
      end

    end
  end
end
