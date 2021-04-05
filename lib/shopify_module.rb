module ShopifyModule

    def activate_session shop_id:
        @shop = Shop.find(shop_id)
        session = ShopifyAPI::Session.new(domain: @shop.shopify_domain, token: @shop.shopify_token, api_version: ShopifyApp.configuration.api_version)
        ShopifyAPI::Base.activate_session(session)
    end

end