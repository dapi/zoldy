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

  def self.generate_id
    HexNumber.new rand(2**32..2**64 - 1)
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
    id:,
    public_key:,
    transactions: [],
    body: nil,
    network: nil,
    protocol: nil,
    private_key: nil
  )
    Wallet.validate_id! id
    @id = id
    @network = network || Settings.network
    @protocol = protocol || Protocol::VERSION
    @public_key = public_key
    @private_key = private_key
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
    # Which is better?
    # OpenSSL::Digest::SHA256.new(body).hexdigest
    @digest ||= Digest::MD5.hexdigest(body).freeze
  end

  def body
    @body ||= build_body
  end

  def zents
    transactions.map(&:zents).inject(&:+)
  end

  def transaction_valid?(txn)
    raise "Can't validate positive transactions #{txn.id} #{txn.amount} > 0" if txn.amount.positive?

    public_rsa.verify(
      OpenSSL::Digest::SHA256.new,
      Base64.decode64(txn.signature),
      transaction_signature_body(txn)
    )
  end

  def transaction_signature(txn)
    Base64.encode64(
      private_rsa.sign(OpenSSL::Digest::SHA256.new, transaction_signature_body(txn))
    ).delete("\n")
  end

  private

  attr_reader :private_key

  def transaction_signature_body(txn)
    [id, txn.id, txn.time.utc.iso8601, txn.amount.to_i, txn.prefix, txn.bnf, txn.details].join(' ')
  end

  def public_rsa
    OpenSSL::PKey::RSA.new ['-----BEGIN PUBLIC KEY-----', public_key.strip, '-----END PUBLIC KEY-----'].join("\n")
  end

  def private_rsa
    OpenSSL::PKey::RSA.new private_key
  end

  def build_body
    (
      [network, protocol, id, public_key, ''] +
      transactions.map(&:dump)
    ).join LINE_SEPARATOR
  end
end
