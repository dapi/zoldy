# frozen_string_literal: true

require 'spec_helper'

describe ScoreFarmWorker do
  subject(:worker) { described_class.new }

  let(:score) { Zold::Score.parse File.read './spec/fixtures/score_2018-12-03T06:19:25Z-10' }
  let(:next_score) { Zold::Score.parse File.read './spec/fixtures/score_2018-12-03T06:19:25Z-20' }

  before do
    Zoldy.app.scores_store.clear!
    allow_any_instance_of(Zold::Score).to receive(:next).and_return next_score # rubocop:disable RSpec/AnyInstance
  end

  it 'generates new score' do # rubocop:disable RSpec/MultipleExpectations
    expect(described_class).to receive(:perform_async)
    worker.perform
    expect(Zoldy.app.scores_store.best).to eq next_score
  end

  it 'build next from an existen score' do # rubocop:disable RSpec/MultipleExpectations
    expect(described_class).to receive(:perform_async)
    worker.perform score.to_s
    expect(Zoldy.app.scores_store.best).to eq next_score
  end
end
