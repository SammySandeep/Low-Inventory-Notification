require 'benchmark'

class LowInventoryStockService

    attr_reader :shop_id

    def initialize shop_id:
        @shop_id = shop_id
    end

    def execute
        GenerateReportJob.perform_later(shop_id: shop_id, products: low_inventory_variants)
    end

    private

    # REFACTOR WITH SQL
    def low_inventory_variants

        products = Array.new

        time = Benchmark.measure {
            products = Variant.get_low_inventory_variants(shop_id: self.shop_id).values
        }

        # time = Benchmark.measure {
            # shop.variants.each do |variant|
            #     products.push([variant.shopify_variant_id, variant.product.title, variant.sku, variant.threshold]) if variant.quantity <= variant.threshold
            # end
        # }

        puts "\nTIME TAKEN TO FETCH LOW INVENTORY VARIANTS: #{time.real}\n\n"
        
        return products

    end

    def shop
        Shop.find(self.shop_id)
    end

end