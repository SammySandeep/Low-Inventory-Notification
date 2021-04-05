class SyncProductsCompleteJob < ApplicationJob
    include ShopifyModule

    queue_as :default

    def perform shop_id:
        @shop = Shop.find(shop_id)

        @shop.update_attributes(sync_complete: true)
        
        activate_session(shop_id: shop_id)
        current_shop = ShopifyAPI::Shop.current
        SyncProductsCompleteMailer.notify(domain: current_shop.domain, email: current_shop.email).deliver_later
    end

end