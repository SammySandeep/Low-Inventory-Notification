class Shopify::ProductsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :shopify_product_params, only: %i[create update delete]
    before_action :shop_id, only: [:create]
    
  def create
    ProductsCreateWebhookJob.perform_later(shopify_product_params.to_h, shop_id)
    head :ok
  end

  def update
    UpdateProductWebhookJob.perform_later(shopify_product_params.to_h)
    head :ok
  end

  def delete
    DeleteProductWebhookJob.perform_later(shopify_product_params.to_h)
    head :ok
  end

  private

    def shop_id
      Shop.find_by(shopify_domain: request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']).id
    end
      
    def shopify_product_params
      params.permit!
    end  

end