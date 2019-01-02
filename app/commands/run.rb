# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

require 'pp'

module Commands
  # Run internal application ruby methods from console, example:
  #
  # > zoldy Zoldy.app.private_wallets_store.all
  #
  class Run < Base
    def perform(method)
      puts eval(method) # rubocop:disable Security/Eval
    end
  end
end
