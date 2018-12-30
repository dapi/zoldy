# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # developer console
  #
  class Console < Base
    def perform
      Pry.start
    end
  end
end
