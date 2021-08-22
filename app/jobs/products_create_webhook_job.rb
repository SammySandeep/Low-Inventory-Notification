class ProductsCreateWebhookJob < ApplicationJob
    queue_as :default
    
    def perform(shopify_product_params, shop_id)
        @shopify_product_params = shopify_product_params
        @shop_id = shop_id
        product = create_product
        create_variants(product) 
    end

    private

    def create_product
        Product.create!(
            title: @shopify_product_params['title'],
            status: @shopify_product_params['status'],
            shopify_product_id: @shopify_product_params['id'],
            shop_id: @shop_id
        )
    end

    def create_variants(product)
        @shopify_product_params['variants'].each do |shopify_variant_params|
          variant = create_variant(shopify_variant_params, product.id)
        end
    end

    def create_variant(shopify_variant_params, product_id)
        Variant.create!(
          sku: shopify_variant_params['sku'],
          shopify_variant_id: shopify_variant_params['id'],
          product_id: product_id,
          quantity: shopify_variant_params['inventory_quantity'],
          inventory_management: shopify_variant_params['inventory_management'],
          local_threshold: nil,
          shop_id: @shop_id
        )
    end

end