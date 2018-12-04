# HTTP Client of Zold Specitification
#
class ZoldClient
  # @param [Remote] remote node
  #
  def initialize(remote)
    @remote = remote
  end

  def get_home
    get
  end

  def get_remotes
    response = get('/remotes')

    validate_status response.code, 200
    validate_content_type response.headers, 'application/json'

    Remotes.new(
      JSON.parse(response.body)['all'].map do |r|
        # TODO Move to spec
        # {"host"=>"88.198.13.175", "port"=>4096, "score"=>255, "errors"=>4, "default"=>false, "home"=>"http://88.198.13.175:4096/"}
        Remote.new host: r['host'], port: r['port'], score: r['score'], remotes_count: r['remotes']
      end
    ).freeze
  end

  private

  attr_reader :remote

  delegate :get, :put, to: :http_client

  def validate_content_type headers, type
    ct = headers['Content-Type']
    raise "Wrong content_type (#{ct} != #{type})" unless ct == type
  end

  def validate_status response_status, status
    raise "Wrong response status #{response_status} <> #{status}" unless response_status == status
  end

  def http_client
    HttpClient.new remote.uri, protocol: Zoldy.protocol
  end
end
