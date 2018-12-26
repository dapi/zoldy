node: bundle exec puma config.ru -p 4096
worker: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -v
