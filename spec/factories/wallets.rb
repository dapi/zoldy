# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    id { generate :wallet_id }
    network { Settings.network }
    protocol { Protocol::VERSION }
    public_key do
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs6ubaYoNicU9LuvwPtT7aL6+XigswJquSeioEHwSGyd77dl4LcZwnq0gmokRit2wk0Dssmo7eIP0CpBixJsvdOJLyltveOpLo3Y7XqrH+1PlRS3iaG7+izanRz2gGrVSeqz5XJaiGSvRwIMSewRtI4PuiGBJABqc5SWF226FNnWyByVWNZ9xk66vPl6qJcUoeMounr3sOQmXWGWNOlB6gHbLoGiZg6KZrOHLzcINT/dONmdqXmmRjn7FWSXzycWdix7NdiltT8swJn/JXbtrThh9CSrdd2WHWtCtoNQnI95HNjh5TGlylqCi3JmtjGv03M0avdafd94vkchkcJQRhwIDAQAB' # rubocop:disable Metrics/LineLength
    end
    transactions { Array.new(10) { build :wallet_transaction } }

    initialize_with { new(attributes) }
  end
end
