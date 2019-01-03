# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Format utilities
#
module ConsoleFormats
  private

  def time_format(time)
    time.localtime.strftime '%Y-%m-%d %H:%M:%S'
  end
end
