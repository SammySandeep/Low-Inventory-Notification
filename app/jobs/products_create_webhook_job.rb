class ProductsCreateWebhookJob < ApplicationJob
    def perform(product_params, shop_id)
        @product_params = product_params
        @shop_id = shop_id
        product = create_product
        if @product_params['variants'].any?
            create_variants(product) 
        end
    end

    private

    def create_product
        Product.create(
            title: @product_params['title'],
            shopify_product_id: @product_params['id'],
            shop_id: @shop_id
        )
    end

    def create_variants(product)
        @product_params['variants'].each do |variant|
          variant = create_variant(variant, product.id)
        end
    end

    def create_variant(variant, product_id)
        Variant.create(
          sku: variant['sku'],
          shopify_variant_id: variant['id'],
          product_id: product_id,
          quantity: variant['inventory_quantity'],
          threshold: nil,
          shop_id: @shop_id
        )
    end

end