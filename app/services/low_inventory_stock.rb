class LowInventoryStock

    attr_reader :shop_setting

    def initialize(shop_setting)
        @shop_setting = shop_setting
    end

    def execute
        products = get_low_stock_products()
        GenerateReportJob.perform_later(shop_setting.shop, products)
    end

    private

    def get_low_stock_products
        products = Array.new

        self.shop_setting.shop.variants.each do |variant|  

             if self.shop_setting.global_threshold >= variant.quantity || variant.threshold >= variant.quantity 
                product = variant.product
                products.push([variant.shopify_variant_id, product.title, variant.sku, variant.threshold])
             end

        end

        return products

    end

end