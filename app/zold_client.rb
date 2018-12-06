# frozen_string_literal: true

# HTTP Client of Zold Specitification
#
class ZoldClient
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

  def version
    response = get '/version'
    validate_response! response, content_type: Protocol::TEXT_CONTENT_TYPE
    response.body
  end

  def remotes
    response = get '/remotes'
    validate_response! response, content_type: Protocol::DATA_CONTENT_TYPE

    build_remotes JSON.parse(response.body)['all']
  end

  private

  attr_reader :remote_node

  def validate_response!(response, status: 200, content_type: nil)
    raise response.return_message unless response.success?

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
