class Sync::WriteProducts
    attr_reader :shop, :products, :next_page
    include ApplicationHelper

    def initialize(shop, products, next_page)
        @shop = shop
        @products = products
        @next_page = next_page
    end

    def execute 
        create_products()
        complete_sync_if_no_next_page()
    end

    private

    def complete_sync_if_no_next_page
        if self.next_page == ""
            shop.shop_setting.update_attributes(sync_complete: true)
            session_activate self.shop
            shop = ShopifyAPI::Shop.current
            NotifyJob.perform_later(shop.domain, shop.email)
        end
    end

    def create_products
        products["products"].each do |product|
            prod = Product.create(
                title: product["title"],
                shopify_product_id: product["id"],
                shop_id: self.shop.id
            )
            create_variants(prod, product["variants"])
        end    
    end

    def create_variants(prod, variants)
        variants.each do |variant|
            Variant.create(
                sku: variant["sku"],
                product_id: prod.id,
                quantity: variant["inventory_quantity"],
                shopify_variant_id: variant["id"],
                threshold: 0,
                shop_id: self.shop.id
            )
        end
    end

end