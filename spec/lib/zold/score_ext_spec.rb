# frozen_string_literal: true

require 'spec_helper'

describe Zold::Score do
  let(:score) { described_class.parse File.read './spec/fixtures/score_2018-12-03T06:19:25Z-2' }

  it { expect(score).to be_valid }

  # "2/7: 2018-12-03T06:19:25Z 94.232.57.6 4096 66Yodh14@1142c2d008235bbe 8GAPAl TzBTr9"
  it 'to_s' do
    expect(described_class.load(score.to_s)).to eq score
  end

  # "7 5c04caed 94.232.57.6 1000 66Yodh14 1142c2d008235bbe 8GAPAl TzBTr9"
  it 'to_text' do
    expect(described_class.load(score.to_text)).to eq score
  end
end
