class GetProductsJob < ApplicationJob
    
    queue_as :default

    def perform shop_id:, current_page_url:
        GetProductsService.new(shop_id: shop_id, current_page_url: current_page_url).execute if current_page_url.present?
    end

end