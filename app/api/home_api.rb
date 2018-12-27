# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Debug / endpoint
#
class HomeAPI < Grape::API
  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  desc 'ping node'
  get '/' do
    present(
      version: Zoldy.version,
      alias: Settings.node_alias,
      network: Settings.network,
      protocol: Protocol::VERSION,
      score: Zoldy.app.scores_store.best.to_h,
      pid: Process.pid,
      processes: 1, # TODO: get it from Puma wokers size
      cpus: Concurrent.processor_count,
      memory: GetProcessMem.new.bytes.to_i,
      platform: RUBY_PLATFORM,
      load: Usagewatch.uw_load.to_f,
      threads: "#{Thread.list.select { |t| t.status == 'run' }.count}/#{Thread.list.count}",
      wallets: Zoldy.app.wallets_store.count,
      remotes: Zoldy.app.remotes_store.alive.count,
      nscore: Zoldy.app.remotes_store.nscore,
      entrance: {
        history_size: 0, # Hstr is the amount of recently processed PUSH requests;
        speed: 0, # Spd is the average amount of time in seconds the node spends per each PUSH request processing
        queue: Sidekiq::Queue.all.map(&:size).inject(&:+)
      },
      date: Time.now.utc.iso8601,
      hours_alive: (Zoldy.app.uptime / (60 * 60)).round(2),
      home: Settings.home
    )
  end
end
