# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Console commands executor
#
module Commands
  LIST = [ShowStatus, ShowRemotes, CreateWallet, ShowAnalytics].freeze

  def self.head
    "Zoldy #{Zoldy::VERSION}, #{Zoldy.env}"
  end

  def self.run(argv)
    from_command_to_class(argv.shift).new.perform(*argv)
  end

  def self.from_command_to_class(command)
    # Get command class from console command name:
    #
    # Example:
    # show_commands -> Commands::ShowCommands
    #
    ['Commands', command.camelize].join('::').constantize
  end

  def self.from_class_to_command(command_class)
    command_class.name.split('::').last.underscore
  end
end
