# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe WalletsStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('wallets') }

  let(:score)  { build(:score).next }
  let(:wallet) { build :wallet }

  before do
    store.clear!
  end

  context 'when no wallets saved' do
    let(:wallet_id) { generate :wallet_id }

    it do
      expect(store).not_to be_exists(wallet_id)
    end

    it do
      expect(store).not_to be_copy(wallet)
    end
  end

  context 'when there is one saved wallet' do
    before do
      store.save_copy! wallet
    end

    it 'find a wallet' do
      expect(store.find(wallet.id)).to eq wallet
    end

    it 'returns wallet`s size' do
      expect(store.wallet_size(wallet.id)).to eq wallet.body.size
    end

    it 'has exactly one wallet' do
      expect(store.count).to eq 1
    end

    it 'exists' do
      expect(store).to be_exists(wallet.id)
    end

    it 'has a copy' do
      expect(store).to be_copy(wallet)
    end

    it { expect(store.count).to eq 1 }
    it { expect(store).to be_exists(wallet) }
    it { expect(store.send(:total_scores_of_copy, wallet)).to be_nil }

    context 'when one node confirmed' do
      before do
        store.save_score! wallet, score
      end

      it { expect(store.send(:total_scores_of_copy, wallet)).to eq score.value }
    end
  end

  context 'when there are a few wallets' do
    let(:low_score)     { build(:score).next }
    let(:high_score)    { low_score.next }
    let(:highest_score) { high_score.next }
    let(:wallet_id)     { generate :wallet_id }
    let(:wallet1)       { build :wallet, id: wallet_id }
    let(:wallet2)       { build :wallet, id: wallet_id }
    let(:wallet3)       { build :wallet, id: wallet_id }

    before do
      store.save_copy! wallet3
      store.save_score! wallet3, highest_score

      store.save_copy! wallet1
      store.save_score! wallet3, low_score

      store.send :select_best!, wallet_id
    end

    it { expect(store.count).to eq 1 }
    it { expect(store).to be_exists(wallet3) }

    context 'when saves wallet with higgest score' do
      before do
        store.save_copy! wallet2
        store.save_score! wallet3, high_score
        store.send :select_best!, wallet_id
      end

      it { expect(store.count).to eq 1 }
      it { expect(store).to be_exists(wallet3) }
    end
  end
end
