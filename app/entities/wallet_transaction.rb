# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Transaction from Wallet copy
#
class WalletTransaction
  ZENTS_IN_ZOLD = 4_294_967_296
  LINE_SPLITTER = ';'

  # The ledger includes transactions, one per line. Each transaction line contains fields separated by a semi-colon:
  # 1. id : Transaction ID, an unsigned 16-bit integer, 4-symbols hex; 9
  # 2. time : date and time, in ISO 8601 format, 20 symbols;
  # 3. amount : Zents, a signed 64-bit integer, 16-symbols hex;
  # 4. prefix : Payment prefix, 8-32 symbols;
  # 5. bnf : Wallet ID of the beneficiary, 16-symbols hex;
  # 6. details : Arbitrary text, matching /[a-zA-Z0-9 -.]{1,512}/ ;
  # 7. signature : RSA signature, 684 symbols in Base64.
  #
  attr_reader :id, :time, :amount, :prefix, :bnf, :details, :signature

  def self.load(body) # rubocop:disable Metrics/MethodLength
    id, time, amount, prefix, bnf, details, signature = body.split LINE_SPLITTER
    WalletTransaction.new(
      id: HexNumber.parse(id),
      time: Time.parse(time),
      amount: HexNumber.parse(amount),
      prefix: prefix,
      bnf: bnf,
      details: details,
      signature: signature,
      body: body
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists
    id:,
    time:,
    amount:,
    prefix:,
    bnf:,
    details:,
    signature:,
    body: nil
  )
    @id        = id
    @time      = time
    @amount    = amount
    @prefix    = prefix
    @bnf       = bnf
    @details   = details
    @signature = signature
    @body      = body
  end

  def dump
    [id, time.utc.iso8601, amount, prefix, bnf, details, signature].join(LINE_SPLITTER).freeze
  end

  def zents
    amount.to_i
  end

  def zolds
    zents.to_f / ZENTS_IN_ZOLD
  end

  private

  attr_reader :body

  def fields
    @fields ||= body.split LINE_SPLITTER
  end
end
