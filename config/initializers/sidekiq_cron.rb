Sidekiq::Cron::Job.create(
  name: "Expire requests",
  cron: "0 3 * * *",
  class: "CancelRequestJob"
)
