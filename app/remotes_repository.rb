class RemotesRepository
  def count
    remote_nodes.count
  end

  def nscore
    remote_nodes.map(&:score).inject(&:+) || 0
  end

  def remote_nodes
    []
  end
end
