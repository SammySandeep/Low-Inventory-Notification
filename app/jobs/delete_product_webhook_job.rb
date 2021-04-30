class DeleteProductWebhookJob < ApplicationJob
    
    def perform(product_params)
        product = Product.find_by_shopify_product_id(product_params['id'])
        if !product.nil?
            product.destroy
        end
    end

end