class SyncProductsJob < ApplicationJob

    queue_as :default

    def perform shop_id:
        GetProductsJob.perform_later(shop_id: shop_id, current_page_url: "first_page")
    end

end