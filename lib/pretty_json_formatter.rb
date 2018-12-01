# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'json'

# Pretty format JSON in grape middleware
#
class PrettyJSONFormatter
  def self.call(object, _env)
    JSON.pretty_generate(object)
  end
end
