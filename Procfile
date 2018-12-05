node: bundle exec puma config.ru -p 4096
scores_farm_worker: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -e production -q scores_farm -v
default_worker: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -e production -q critical -q default -v
