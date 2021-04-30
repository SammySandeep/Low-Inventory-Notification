class UpdateProductWebhookJob < ApplicationJob
    def perform(product_params)
        @product = Product.find_by(shopify_product_id: product_params['id'])
        @product.title = product_params['title']
        @product.shopify_product_id = product_params['id']
        @product.save
        if product_params['variants'].any?
            product_params['variants'].each do |variant|
                variant_update = Variant.find_by(shopify_variant_id: variant['id'])
                if variant_update.nil?
                    variant = create_variant(variant, @product.id, @product.shop_id)
                else
                    variant_update.sku = variant['sku']
                    variant_update.quantity = variant['inventory_quantity']
                    variant_update.save
                end  
            end
            check_variant_removed_in_shopify product_params
        end
    end

    private

    def create_variant(variant, product_id, shop_id)
        Variant.create(
          sku: variant['sku'],
          shopify_variant_id: variant['id'],
          product_id: product_id,
          quantity: variant['inventory_quantity'],
          threshold: nil,
          shop_id: shop_id
        )
    end

    def check_variant_removed_in_shopify product_params
        @product.variants.each do |saved_variant|
            variant_found = false
            product_params['variants'].each do |new_variant|
                if saved_variant.shopify_variant_id	== new_variant['id']
                    variant_found = true
                    break
                end
            end
            if !variant_found
                saved_variant.destroy
            end
        end
    end
    
end