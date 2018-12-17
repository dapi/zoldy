# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresWatchDog do
  subject(:worker) { described_class.new }

  let(:period) { 12.hours }

  before do
    Sidekiq::Testing.fake!
    Sidekiq::Queue.new.clear
    Sidekiq::ScheduledSet.new.clear
    ScoreWorker.jobs.clear
    allow_any_instance_of(described_class).to receive(:period_between_scores).and_return period
  end

  context 'when there are no score workers in queue' do
    before do
      described_class.new.perform
    end

    it 'start new ScoreWorker' do
      expect(ScoreWorker.jobs.size).to eq 1
    end
  end

  context 'when there is actual score worker in queue' do
    before do
      allow_any_instance_of(described_class).to receive(:last_time).and_return Time.now
      described_class.new.perform
    end

    it "don't start a worker" do
      expect(ScoreWorker.jobs.size).to eq 0
    end
  end

  context 'when there is not actual score worker in queue' do
    it 'starts new worker' do
      allow_any_instance_of(described_class).to receive(:last_time).and_return Time.now - period
      described_class.new.perform
      expect(ScoreWorker.jobs.size).to eq 1
    end
  end
end
