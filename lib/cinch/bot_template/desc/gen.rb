require 'paint'
module Cinch
  module BotTemplate
    module Descs
      module Gen
        module_function

        def Gen
          ERB.new(
          <<~GEN
          --'<%= Paint['#{Pathname($PROGRAM_NAME).basename} gen', 'orange', :bold ] %>' will prompt for information
          --then will generate the following when given no other options.
          --* executable bot file
          --* config file
          --* optimal directory structure
          <%= Paint['MULTI SERVER USE', 'white', :bold] %>:
          --If '--multi-server' or '-m' is used, the generator will
          --output a config and/or bot file that is set in a way to
          --allow multiple networks/servers.
          GEN
          ).result
        end
      end

    end
  end
end
