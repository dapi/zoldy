# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Provide 'help' console command
  #
  class Help < Base
    def perform
      puts 'Run `zoldy show_commands` to view available commands list'
      puts 'Run `zoldy console` to enter a developer console'
    end
  end
end
