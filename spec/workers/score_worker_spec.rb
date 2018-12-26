# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoreWorker do
  subject(:worker) { described_class.new }

  let(:score) { build(:score).next }
  let(:next_score) { score.next }

  before do
    Zoldy.app.scores_store.clear!
    allow_any_instance_of(Zold::Score).to receive(:next).and_return next_score
  end

  it 'build next from an existen score' do # rubocop:disable RSpec/MultipleExpectations
    expect(described_class).to receive(:perform_async)
    worker.perform
    expect(Zoldy.app.scores_store.best).to eq next_score
  end
end
