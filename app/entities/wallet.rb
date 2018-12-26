# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'digest'

# Wallet entity
#
class Wallet
  LINE_SEPARATOR = "\n"

  attr_reader :id, :network, :protocol, :public_key, :transactions

  def self.validate_id!(id)
    raise "Wrong Wallet ID (#{id}) format (#{Protocol::WALLET_ID_FORMAT})" unless Protocol::WALLET_ID_FORMAT =~ id
  end

  def self.load(body)
    lines = body.split(LINE_SEPARATOR)
    Wallet.new(
      network: lines[0],
      protocol: lines[1],
      id: lines[2],
      public_key: lines[3],
      transactions: Array(lines.slice(5, lines.length - 5)).map { |t| WalletTransaction.load t }.freeze,
      body: body
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists
    network:,
    protocol:,
    id:,
    public_key:,
    transactions: [],
    body: nil
  )
    Wallet.validate_id! id
    @id = id
    @network = network
    @protocol = protocol
    @public_key = public_key
    @transactions = transactions
    @body = body
  end

  def to_s
    id
  end

  def ==(other)
    id == other.id && digest == other.digest
  end

  def digest
    @digest ||= Digest::MD5.hexdigest(body).freeze
  end

  def body
    @body ||= build_body
  end

  def zents
    transactions.map(&:zents).inject(&:+)
  end

  private

  def build_body
    (
      [network, protocol, id, public_key, ''] +
      transactions.map(&:dump)
    ).join LINE_SEPARATOR
  end
end
