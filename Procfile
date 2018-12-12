node: bundle exec puma config.ru -p 4096
worker0: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -q worker0 -q default -v
worker1: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -q worker1 -q default -v
worker2: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -q worker2 -q default -v
worker3: bundle exec sidekiq -r ./config/environment.rb -C ./config/sidekiq.yml -q worker3 -q default -v
