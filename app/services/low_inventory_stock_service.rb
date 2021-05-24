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

    def low_inventory_variants
        Variant.get_low_inventory_variants(shop_id: self.shop_id).first["variants_csv"].prepend("Variant ID,Product Title,SKU,Threshold\n")
    end

    def shop
        Shop.find(self.shop_id)
    end

end