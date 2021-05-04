env :PATH, ENV['PATH']

set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every 1.minute do
    rake "check_low_inventory_stock:every1min"
end