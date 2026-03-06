require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Original
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_storage.variant_processor = :mini_magick
    config.active_job.queue_adapter = :sidekiq
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.smtp_settings = {
    address: "email-smtp.ap-northeast-1.amazonaws.com",
    port: 587,
    domain: "flaag.net",
    user_name: ENV["SES_USER"],
    password: ENV["SES_API_KEY"],
    authentication: :login,
    enable_starttls_auto: true
  }
  end
end
