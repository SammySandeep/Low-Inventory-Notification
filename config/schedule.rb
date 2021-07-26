env :PATH, ENV['PATH']

set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

job_type :rbenv_runner, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; cd :path && RUBYOPT='-W:no-deprecated -W:no-experimental' bin/rails runner -e :environment ':task' :output }

# TEST
every 1.minute do
    runner "ShopSetting.where(alert_frequency: 1).each { |shop_setting| LowInventoryStockJob.perform_later(shop_id: shop_setting.shop.id) }"
end

# LOW INVENTORY STOCK JOB
every 6.hours do
    runner "ShopSetting.where(alert_frequency: 6).each { |shop_setting| LowInventoryStockJob.perform_later(shop_id: shop_setting.shop.id) }"
end

every 12.hours do
    runner "ShopSetting.where(alert_frequency: 12).each { |shop_setting| LowInventoryStockJob.perform_later(shop_id: shop_setting.shop.id) }"
end

every 24.hours do
    runner "ShopSetting.where(alert_frequency: 24).each { |shop_setting| LowInventoryStockJob.perform_later(shop_id: shop_setting.shop.id) }"
end

# REPORTS CLEANUP JOB
every 1.day do
    runner "ReportsCleanupJob.perform_later"
end