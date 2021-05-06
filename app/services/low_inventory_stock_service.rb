class LowInventoryStockService

    attr_reader :shop_id

    def initialize shop_id:
        @shop_id = shop_id
    end

    def execute
        GenerateReportJob.perform_later(shop_id: shop_id, products: low_inventory_products)
    end

    private

    # REFACTOR
    def low_inventory_products
        products = Array.new

        shop.variants.each do |variant|
            products.push([variant.shopify_variant_id, variant.product.title, variant.sku, variant.threshold]) if variant.quantity <= variant.threshold
        end

        return products
    end

    def shop
        Shop.find(self.shop_id)
    end

end