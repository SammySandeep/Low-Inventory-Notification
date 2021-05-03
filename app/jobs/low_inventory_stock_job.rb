class LowInventoryStockJob < ApplicationJob
    queue_as :default

    def perform shop_id:
        LowInventoryStockService.new(shop_id: shop_id).execute
    end

end