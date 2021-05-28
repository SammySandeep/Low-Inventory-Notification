class WriteProductsJob < ApplicationJob

    queue_as :default

    def perform shop_id:, products:, next_page_url:
        
        Product.write_products_from_shopify_products_json(shop_id: shop_id, shopify_products_json: products["products"].to_json)
        Variant.write_variants_from_shopify_products_json(shop_id: shop_id, shopify_products_json: products["products"].to_json)

        if next_page_url.present?
            GetProductsJob.perform_later(shop_id: shop_id, current_page_url: next_page_url)
        else
            SyncProductsCompleteJob.perform_later(shop_id: shop_id)
        end

    end

end
