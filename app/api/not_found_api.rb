# frozen_string_literal: true

class NotFoundAPI < Grape::API
  helpers do
    include AutoLogger::Named.new(name: :not_found_api)
  end

  desc 'catch all not founds'
  get '*' do
    logger.info "Get (not_found) #{request.path} with headers #{headers} and params #{params}"
    status 404
    present status: :not_found
  end
end
