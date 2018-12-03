# frozen_string_literal: true

require 'json'

class PrettyJSONFormatter
  def self.call(object, _env)
    JSON.pretty_generate(object)
  end
end
