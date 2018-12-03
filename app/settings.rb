class Settings < Settingslogic
  source "config/settings.yml"

  def strength
    Zold::Score::STRENGTH
  end

  def protocol
    Zoldy::Middleware::PROTOCOL
  end

  def node_alias
    [host, port].join ':'
  end
end
