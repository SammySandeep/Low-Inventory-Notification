class Shopify::ProductsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :product_params, only: %i[create]

    def create
      head :ok
      shop_id = get_shop_id
      ProductsCreateWebhookJob.perform_now(product_params.to_h, shop_id)
  
    #   ProductsCreateWebhookJob.perform_later(product_params())   
    end

    # def update
    #    head :ok
    #    UpdateProduct.perform_async(product_params.to_h)
    # end

    # def delete
    #   head :ok
    #   DeleteProduct.perform_async(product_params.to_h)
    #  end
    def get_shop_id
      Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']).id
    end
    
    def product_params
        params.permit!
    end
    
end