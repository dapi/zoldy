# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Methods to work with saved scores
#
module RemotesStoreScores
  SCORE_ALIVE_PERIOD = 15.minutes

  def alive?(node_alias)
    time = touched_at node_alias
    time.present? && time > Time.now - SCORE_ALIVE_PERIOD
  end

  def touched_at(node_alias)
    File.mtime build_score_dir node_alias
  rescue Errno::ENOENT
    nil
  end

  def nscore
    Dir[dir.join('*/score')].map { |f| File.read(f).to_i }.inject(&:+)
  end

  def update_score(node_alias, score)
    add node_alias
    File.write build_score_dir(node_alias), score.to_s
  end

  def get_score(node_alias)
    node_alias = node_alias.node_alias if node_alias.is_a? Remote
    Zold::Score.load File.read(build_score_dir(node_alias))
  rescue Errno::ENOENT
    nil
  end

  private

  def build_score_dir(node_alias)
    build_remote_dir(node_alias).join('score')
  end
end
