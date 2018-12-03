node: bundle exec puma config.ru -p 4096
worker: bundle exec sidekiq -r ./config/boot.rb -C ./config/sidekiq.yml
