class WriteProductsJob < ApplicationJob

    queue_as :default

    def perform shop_id:, products:, next_page_url:
        Sync::WriteProductsService.new(shop_id: shop_id, products: products, next_page_url: next_page_url).execute
    end

end