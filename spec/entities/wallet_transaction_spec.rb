# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe WalletTransaction do
  subject(:wallet_transaction) { described_class.load body }

  let(:body) do
    '003f;2018-07-11T19:23:44Z;0000000100000000;xKcsyby2;17737fee5b825835;Hosting bonus for 138.201.231.23 4096 24;'
  end

  it do
    expect(wallet_transaction.amount).to eq '0000000100000000'
  end
end
