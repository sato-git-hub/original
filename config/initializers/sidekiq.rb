# "REDIS_URL",がなければredis://localhost:6379/1を代入
redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/1")
# Sidekiq が使う Redis の接続先を指定 実行と登録先を統一
# ジョブを実行する側
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end
# ジョブを登録する側
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end