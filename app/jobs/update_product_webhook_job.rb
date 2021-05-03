class UpdateProductWebhookJob < ApplicationJob
    queue_as :default

    def perform(shopify_product_params)
        @shopify_product_params = shopify_product_params
        @product = Product.find_by(shopify_product_id: @shopify_product_params['id'])
        if !(@product.title == @shopify_product_params['title'])
            @product.title = @shopify_product_params['title']
            @product.save!
        end
        shopify_variant_ids = @product.variants.pluck(:shopify_variant_id)
        @shopify_product_params['variants'].each do |shopify_variant_params|
            @variant = Variant.find_by(shopify_variant_id: shopify_variant_params['id'])
            if @variant.nil?
                @variant = create_variant(shopify_variant_params, @product.id, @product.shop_id)
            else
                @variant.sku = shopify_variant_params['sku']
                @variant.quantity = shopify_variant_params['inventory_quantity']
                @variant.save!
            end  
            shopify_variant_ids.delete(shopify_variant_params['id'])
        end
        Variant.where(shopify_variant_id: shopify_variant_ids).destroy_all if !shopify_variant_ids.empty?
    end

    private

    def create_variant(shopify_variant_params, product_id, shop_id)
        Variant.create!(
          sku: shopify_variant_params['sku'],
          shopify_variant_id: shopify_variant_params['id'],
          product_id: product_id,
          quantity: shopify_variant_params['inventory_quantity'],
          threshold: nil,
          shop_id: shop_id
        )
    end
    
end