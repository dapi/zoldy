# frozen_string_literal: true

# Eumerabe Remote collection
#
class Remotes
  include Enumerable

  delegate :each, :join, :empty?, :include?, :to_a, to: :list

  def initialize(list = [])
    @list = Array(list)
  end

  def to_yaml
    list.map(&:to_h).to_yaml
  end

  def nscore
    list.map(&:score).inject(&:+) || 0
  end

  def <<(remote)
    self.class.new list + [remote]
  end

  def +(other)
    self.class.new((to_a + other.to_a).uniq)
  end

  private

  attr_reader :list
end
