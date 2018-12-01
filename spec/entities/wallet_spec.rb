# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe Wallet do
  subject(:wallet) { build :wallet }

  let(:other_wallet) { build :wallet }

  it { expect(wallet).not_to eq other_wallet }

  context 'when load wallet' do
    subject(:wallet) { described_class.load body }

    let(:body) { File.read './spec/fixtures/wallet3' }

    it do
      expect(wallet).to be_a described_class
    end

    it do
      expect(wallet.transactions.count).to eq 230
    end
  end
end
