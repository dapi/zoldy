def app
Rack::Builder.new do
use RequestStore::Middleware
run MyApp
end
end
