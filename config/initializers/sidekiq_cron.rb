return if ENV["SECRET_KEY_BASE_DUMMY"]
Sidekiq::Cron::Job.create(
  name: "Expire requests",
  cron: "* 12 * * *",
  class: "CancelRequestJob"
)
