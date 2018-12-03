# frozen_string_literal: true

# Eumerabe Remote collection
#
class Remotes
  include Enumerable

  delegate :each, :join, :empty?, :include?, to: :list

  def initialize(list = [])
    @list = Array(list)
  end

  def nscore
    list.map(&:score).inject(&:+) || 0
  end

  def <<(remote)
    self.class.new list + [remote]
  end

  private

  attr_reader :list
end
