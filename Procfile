node: bundle exec puma config.ru -p 4096
scores_worker: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -v -q scores
default_worker: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -v -q default -q critical
