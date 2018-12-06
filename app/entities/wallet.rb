# frozen_string_literal: true

# Wallet entity
#
class Wallet
  attr_reader :id, :body

  def self.validate_id!(id)
    raise "Wrong Wallet ID (#{id}) format (#{Protocol::WALLET_ID_FORMAT})" unless Protocol::WALLET_ID_FORMAT =~ id
  end

  def initialize(id:, body:)
    @id = id
    @body = body
    Wallet.validate_id! id
  end

  def ==(other)
    id == other.id && body == other.body
  end
end
