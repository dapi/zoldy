# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe Zold::Score do
  let(:score) { build(:score).next }

  it { expect(score).to be_valid }

  it 'to_s' do
    expect(described_class.load(score.to_s)).to eq score
  end
end
