# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe Commands::CreateWallet, command: true do
  context 'when run #create_wallet' do
    let!(:wallet) { described_class.new.create_wallet }

    it 'returns valid wallet' do
      expect(wallet).to be_valid_private_key
    end

    it 'has findable wallet' do
      expect(Zoldy.app.wallets_store.find(wallet.id)).to eq wallet
    end

    it 'has saved wallet as private' do
      expect(Zoldy.app.private_wallets_store.all).to include wallet
    end
  end

  context 'when run #perform' do
    it do
      expect { described_class.new.perform }.not_to raise_error
    end
  end
end
