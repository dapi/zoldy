class TestWorker
  include Sidekiq::Worker
  include AutoLogger

  sidekiq_options(
    retry: true,
    queue: :default,
    unique: :until_and_while_executing,
    on_conflict: :log,
    unique_args: ->(args) { args }
  )

  def perform(arg, timeout = 30)
    logger.info "Start #{arg}"
    sleep timeout
    logger.info "Finish #{arg}"
  end
end
