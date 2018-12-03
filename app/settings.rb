class Settings < Settingslogic
  source "config/settings.yml"

  def strength
    Zold::Score::STRENGTH
  end

  def node_alias
    [host, port].join ':'
  end
end
