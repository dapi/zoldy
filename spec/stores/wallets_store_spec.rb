# frozen_string_literal: true

require 'spec_helper'

describe WalletsStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('wallets') }

  let(:wallet) { build :wallet }

  before do
    store.clear!
  end

  context 'when there is one saved wallet' do
    before do
      store.save! wallet
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
  end
end
