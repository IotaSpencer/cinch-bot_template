require 'paint'
module Cinch
  module BotTemplate
    module Descs

      module Plugin
        module_function

        def Gen
          ERB.new(
              <<~GEN
                --'<%= Paint['#{Pathname($PROGRAM_NAME).basename} plugin gen', 'orange', :bold] %>'
                --will prompt for information,
                --then will start generating either one or multiple plugin files,
                --based on how many plugin names it was given.
          GEN
          ).result
        end
      end

    end
  end
end
