class VersionAPI < Grape::API
  format :txt

  helpers do
    include AutoLogger::Named.new(name: :version_api)
  end

  desc 'Undocumented endpoint. We must implement it to allow other nodes to add as'
  get :version do
    Zoldy::VERSION.to_s
  end
end
