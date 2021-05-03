class DeleteProductWebhookJob < ApplicationJob
    queue_as :default

    def perform(shopify_product_params)
        product = Product.find_by_shopify_product_id(shopify_product_params['id'])
        if !product.nil?
            product.destroy
        end
    end

end