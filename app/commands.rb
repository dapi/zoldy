# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Console commands executor
#
module Commands
  UnknownCommand = Class.new StandardError

  LIST = [ShowStatus, ShowRemotes, CreateWallet, ShowAnalytics, ShowCommands, Help, Console].freeze

  def self.head
    "Zoldy #{Zoldy::VERSION}, #{Zoldy.env}"
  end

  def self.run(argv)
    from_command_to_class(argv.shift).new.perform(*argv)
  rescue UnknownCommand => err
    puts "Unknown command: '#{err}'"
    puts
    puts '---'
    Commands::Help.new.perform
  end

  # Get command class from console command name:
  #
  # Example:
  # show_commands -> Commands::ShowCommands
  #
  def self.from_command_to_class(command)
    command_class = ['Commands', command.camelize].join('::')
    raise UnknownCommandcommand unless LIST.map(&:to_s).include? command_class

    command_class.constantize
  end

  def self.from_class_to_command(command_class)
    command_class.name.split('::').last.underscore
  end
end
