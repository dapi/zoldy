# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe ScoresStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('scores') }

  before do
    store.clear!
  end

  context 'when there are two saved wallets with one time' do
    let(:worst_score) { build(:score).next }
    let(:better_score)  { worst_score.next }

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

    it 'find by time' do
      expect(store.find_by_time(better_score.time)).to eq better_score
    end

    context 'when removed' do
      before do
        store.remove_by_time better_score.time
      end

      it do
        expect(store.find_by_time(better_score.time)).to be_nil
      end
    end

    context 'when addes another one' do
      let(:best_of_the_best) { build(:score, time: Time.now - 100).next.next.next }

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
