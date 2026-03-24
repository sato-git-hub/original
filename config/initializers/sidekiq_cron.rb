Sidekiq::Cron::Job.create(
  name: "Expire requests",
  cron: "* 12 * * *",
  class: "CancelRequestJob"
)
