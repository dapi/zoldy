# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresWatchDog do
  subject(:worker) { described_class.new }

  before do
    Sidekiq::Queue.new.clear
    Sidekiq::ScheduledSet.new.clear
  end

  it do
    described_class.new.perform
    expect(ScoreWorker.jobs.size + Sidekiq::Queue.new('worker0').size).to eq ScoresWatchDog::PROCESSORS_COUNT
  end
end
