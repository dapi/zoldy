# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Wallet's transaction
#
# The ledger includes transactions, one per line. Each transaction line contains fields separated by a semi-colon:
# 1. id : Transaction ID, an unsigned 16-bit integer, 4-symbols hex; 9
# 2. time : date and time, in ISO 8601 format, 20 symbols;
# 3. amount : Zents, a signed 64-bit integer, 16-symbols hex;
# 4. prefix : Payment prefix, 8-32 symbols;
# 5. bnf : Wallet ID of the beneficiary, 16-symbols hex;
# 6. details : Arbitrary text, matching /[a-zA-Z0-9 -.]{1,512}/ ;
# 7. signature : RSA signature, 684 symbols in Base64.
#
class Transaction
  attr_reader :id, :time, :amount, :prefix, :bnf, :details, :signature
end
