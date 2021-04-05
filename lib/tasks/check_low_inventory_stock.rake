namespace :check_low_inventory_stock do
  
  
    task every1min: :environment do
        check_shop_settings_frequency(1)
    end

    def check_shop_settings_frequency(frequency)
        ShopSetting.all.each do |shop_setting|
            if shop_setting.alert_frequency == frequency
                LowInventoryStockJob.perform_later(shop_setting)
            end
        end
    end
    
end