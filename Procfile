node: bundle exec puma config.ru -p 4096
worker0: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -q worker0 -q default -v
