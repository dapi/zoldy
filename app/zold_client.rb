# frozen_string_literal: true

# HTTP Client of Zold Specitification
#
class ZoldClient
  # @param [Remote] remote node
  #
  def initialize(remote)
    @remote = remote
  end

  def home
    get
  end

  def remotes
    response = get('/remotes')

    raise response.return_message unless response.success?

    validate_status response.code, 200
    validate_content_type response.headers, 'application/json'

    build_remotes JSON.parse(response.body)['all']
  end

  private

  attr_reader :remote

  def build_remotes(array)
    array.map do |r|
      Remote.new host: r['host'], port: r['port'], score: r['score'], remotes_count: r['remotes']
    end.to_set.freeze
  end

  delegate :get, :put, to: :http_client

  def validate_content_type(headers, type)
    ct = headers['Content-Type']
    raise "Wrong content_type (#{ct} != #{type})" unless ct == type
  end

  def validate_status(response_status, status)
    raise "Wrong response status #{response_status} <> #{status}" unless response_status == status
  end

  def http_client
    HttpClient.new remote.uri, protocol: Zoldy.protocol
  end
end
