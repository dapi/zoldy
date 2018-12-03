class Settings < Settingslogic
  source "config/settings.yml"

  def node_alias
    [host, port].join ':'
  end
end
