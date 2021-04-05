class LowInventoryStockJob < ApplicationJob
    queue_as :default

    def perform(shop_setting)
        LowInventoryStock.new(shop_setting).execute()
    end
    

end