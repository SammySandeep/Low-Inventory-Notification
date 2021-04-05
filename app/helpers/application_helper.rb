module ApplicationHelper
    def session_activate shop
        session = ShopifyAPI::Session.new(domain: shop.shopify_domain, token: shop.shopify_token, api_version: '2020-04')
        ShopifyAPI::Base.activate_session(session)
    end

    def find_shop_by_shopify_domain(shopify_domain)
        Shop.find_by_shopify_domain(shopify_domain)
    end
end
