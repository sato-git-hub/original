redis_url = ENV.fetch("REDIS_URL")
# Sidekiq が使う Redis の接続先を指定 実行と登録先を統一
# ジョブを実行する側
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end
# ジョブを登録する側
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
