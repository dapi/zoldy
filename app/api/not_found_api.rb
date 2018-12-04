# frozen_string_literal: true

# This action catches all uncatched requests and log it
#
class NotFoundAPI < Grape::API
  helpers do
    include AutoLogger::Named.new(name: :not_found_api)
  end

  desc 'catch all not founds'
  get '*' do
    logger.info "GET (not_found) #{request.path} with headers #{headers} and params #{params}"
    status 404
    present status: :not_found
  end

  put '*' do
    logger.info "PUT (not_found) #{request.path} with headers #{headers} and params #{params}"
    status 404
    present status: :not_found
  end
end
