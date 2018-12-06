# frozen_string_literal: true

require 'spec_helper'

describe ScoresStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('scores') }

  before do
    store.clear!
  end

  context 'when there is two saved wallet with one time' do
    let(:worst_score) { Zold::Score.parse File.read './spec/fixtures/score_2018-12-03T06:19:25Z-2' }
    let(:better_score)  { Zold::Score.parse File.read './spec/fixtures/score_2018-12-03T06:19:25Z-10' }

    before do
      store.save! better_score
      store.save! worst_score
    end

    it 'has only one score' do
      expect(store.all.count).to eq 1
    end

    it 'best is the best' do
      expect(store.best).to eq better_score
    end

    context 'when addes another one' do
      let(:best_of_the_best) { Zold::Score.parse File.read './spec/fixtures/score_2018-12-04T21:52:58Z-292' }

      before do
        store.save! best_of_the_best
      end

      it 'has two scores' do
        expect(store.all.count).to eq 2
      end

      it 'best is the best' do
        expect(store.best).to eq best_of_the_best
      end
    end
  end
end
