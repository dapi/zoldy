# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Methods to work with saved scores
#
module RemotesStoreScores
  def nscore
    Dir[dir.join('*/score')].map { |f| File.read(f).to_i }.inject(&:+)
  end

  def update_score(node_alias, score)
    add node_alias
    File.write build_remote_dir(node_alias).join('score'), score.to_s
  end

  def get_score(remote)
    File.read(build_remote_dir(remote.node_alias).join('score')).to_i
  rescue Errno::ENOENT
    nil
  end
end
