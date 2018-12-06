# frozen_string_literal: true

require 'spec_helper'

describe Wallet do
  subject(:wallet) { build :wallet }

  let(:other_wallet) { Wallet.new(id: wallet.id, body: wallet.body) }

  it 'equals' do
    expect(wallet).to eq other_wallet
  end
end
