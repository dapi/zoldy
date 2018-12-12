# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresWatchDog do
  subject(:worker) { described_class.new }

  before do
    Sidekiq::Queue.new.clear
    Sidekiq::ScheduledSet.new.clear
  end

  it do # rubocop:disable RSpec/MultipleExpectations
    expect { described_class.new.perform }.to change(ScoreWorker.jobs, :size).by(ScoresWatchDog::PROCESSORS_COUNT - 1)
    expect(Sidekiq::Queue.new('worker0').size).to eq 1
  end
end
