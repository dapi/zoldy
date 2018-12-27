# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Hex numbers
#
class HexNumber < Numeric
  def self.parse(txt)
    integer = Integer("0x#{txt}", 16)
    if txt.start_with?('f')
      max = Integer("0x#{'f' * txt.length}", 16)
      integer = integer - max - 1
    end
    new integer
  end

  def initialize(num)
    @num = num
  end

  def ==(other)
    to_s(other.to_s.size) == other.to_s
  end

  def to_s(length = 16)
    format("%0#{length}x", @num).gsub(/^\.{2}/, 'ff')
  end

  def to_i
    @num
  end
end
