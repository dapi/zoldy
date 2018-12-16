# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# HTTP Client of Zold Specitification
#
class ZoldClient
  Error = Class.new StandardError
  NotFound = Class.new Error
  UnknownError = Class.new Error
  # @param [Remote] remote node
  #
  def initialize(remote_node)
    @remote_node = remote_node
  end

  def home
    response = get
    validate_response! response, content_type: Protocol::DATA_CONTENT_TYPE
    JSON.parse(response.body)
  end

  def score
    Zold::Score.new home['score'].slice('host', 'time', 'port', 'suffixes', 'strength', 'invoice').symbolize_keys
  end

  def version
    response = get '/version'
    validate_response! response, content_type: Protocol::TEXT_CONTENT_TYPE
    response.body
  end

  def fetch_wallet(wallet_id)
    response = get '/wallet/' + wallet_id.to_s
    validate_response! response, content_type: Protocol::DATA_CONTENT_TYPE
    Wallet.load JSON.parse(response.body)['body']
  end

  def fetch_wallet_and_score(wallet_id)
    response = get '/wallet/' + wallet_id.to_s
    validate_response! response, content_type: Protocol::DATA_CONTENT_TYPE
    data = JSON.parse response.body
    wallet = Wallet.load data['body']
    score = Zold::Score.new data['score']
            .slice('host', 'time', 'port', 'suffixes', 'strength', 'invoice')
            .symbolize_keys

    [wallet, score]
  end

  def remotes
    response = get '/remotes'
    validate_response! response, content_type: Protocol::DATA_CONTENT_TYPE

    build_remotes JSON.parse(response.body)['all']
  end

  private

  attr_reader :remote_node

  def validate_response!(response, status: 200, content_type: nil)
    unless response.success?
      raise NotFound if response.code == 404

      raise UnknownError, response.return_message
    end

    validate_status response.code, status
    validate_content_type response.headers, content_type
  end

  def build_remotes(array)
    array.map do |r|
      Remote.new host: r['host'], port: r['port'], score: r['score'], remotes_count: r['remotes']
    end.freeze
  end

  delegate :get, :put, to: :http_client

  def validate_content_type(headers, type)
    ct = headers['Content-Type']
    raise "Wrong content_type (#{ct} != #{type})" unless ct.start_with? type
  end

  def validate_status(response_status, status)
    raise "Wrong response status #{response_status} <> #{status}" unless response_status == status
  end

  def http_client
    HttpClient.new remote_node.uri, protocol: Zoldy.protocol
  end
end
