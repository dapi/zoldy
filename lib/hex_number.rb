# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Hex numbers
#
class HexNumber < Integer
  def self.parse(txt)
    integer = Integer("0x#{txt}", 16)
    if txt.start_with?('f')
      max = Integer("0x#{'f' * txt.length}", 16)
      integer = integer - max - 1
    end
    integer
  end

  def to_s(length = 16)
    format("%0#{length}x", self).gsub(/^\.{2}/, 'ff')
  end
end
