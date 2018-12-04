# frozen_string_literal: true

# Application's settings
#
class Settings < Settingslogic
  source 'config/settings.yml'
  namespace Zoldy.env

  def node_alias
    [host, port].join ':'
  end
end
