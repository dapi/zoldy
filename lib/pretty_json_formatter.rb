require 'json'

class PrettyJSONFormatter
  def self.call object, env
    JSON.pretty_generate(object)
  end
end
