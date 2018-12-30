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
    Dir[dir.join('*/score')].map { |f| load_score(f).try(:value) }.compact.inject(&:+)
  end

  def update_score(node_alias, score)
    add node_alias
    File.write build_score_dir(node_alias), score.to_s
    score
  end

  def get_score(node_alias)
    node_alias = node_alias.node_alias if node_alias.is_a? Remote
    load_score build_score_dir(node_alias)
  rescue Errno::ENOENT
    nil
  end

  private

  def build_score_dir(node_alias)
    build_remote_dir(node_alias).join('score')
  end

  def load_score(file)
    Zold::Score.load File.read(file)
  rescue RuntimeError => err
    Zoldy.logger.error "Invalid score for #{file}: #{err}"
    nil
  end
end
