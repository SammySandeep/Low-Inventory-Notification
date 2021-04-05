module ApplicationHelper


    def find_shop_by_shopify_domain(shopify_domain)
        Shop.find_by_shopify_domain(shopify_domain)
    end
end
