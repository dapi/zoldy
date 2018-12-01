# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Transaction from Wallet copy
#
class WalletTransaction
  LINE_SPLITTER = ';'

  attr_reader :id, :time, :amount, :prefix, :bnf, :details, :signature

  def self.load(body) # rubocop:disable Metrics/MethodLength
    id, time, amount, prefix, bnf, details, signature = body.split LINE_SPLITTER
    WalletTransaction.new(
      id: id,
      time: time,
      amount: amount,
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
    [id, time, amount, prefix, bnf, details, signature].join(LINE_SPLITTER).freeze
  end

  private

  attr_reader :body

  def fields
    @fields ||= body.split LINE_SPLITTER
  end
end
