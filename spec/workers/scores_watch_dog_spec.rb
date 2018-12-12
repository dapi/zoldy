# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresWatchDog do
  subject(:worker) { described_class.new }

  before do
    Zoldy.app.scores_store.clear!
  end

  it do
    expect { described_class.new.perform }.to change(ScoreWorker.jobs, :size).by(ScoresWatchDog::PROCESSORS_COUNT)
  end
end
