# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresWatchDog do
  it 'start new ScoreWorker' do
    expect(ScoreWorker).to receive(:perform_async)
    described_class.new.perform
  end
end
