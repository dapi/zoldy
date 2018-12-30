# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show remotes list in console.
  #
  # Usage example
  #
  # > ./bin/console show_commands
  #
  class ShowCommands < Base
    def perform
      print_formatted(
        commands,
        headings: ['Command name', 'Arguments']
      )
    end

    private

    def commands
      Commands::LIST.map do |command_class|
        [
          Commands.from_class_to_command(command_class),
          ''
        ]
      end
    end
  end
end
