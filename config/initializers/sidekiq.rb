Sidekiq.configure_server do |config|
    config.redis = { url: "#{ENV['REDIS_URL']}/0" }
end
  
Sidekiq.configure_client do |config|
    config.redis = { url: "#{ENV['REDIS_URL']}/0" }
end

# Rails.logger = Sidekiq.logger
# ActiveRecord::Base.logger = Sidekiq.logger
