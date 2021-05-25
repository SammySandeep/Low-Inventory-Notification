class AppDeleteWebhookJob < ApplicationJob
    queue_as :default

    def perform(shopify_domain)
        shop = Shop.find_by_shopify_domain(shopify_domain)
        shop.destroy
    end

end
