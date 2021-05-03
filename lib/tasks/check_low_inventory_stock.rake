namespace :check_low_inventory_stock do

    task every1min: :environment do
        check_shop_settings_frequency(1)
    end

    def check_shop_settings_frequency(frequency)
        ShopSetting.where(alert_frequency: 1).each { |shop_setting| LowInventoryStockJob.perform_later(shop_id: shop_setting.shop.id) }
    end

end