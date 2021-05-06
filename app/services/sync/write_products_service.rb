require 'benchmark'

class Sync::WriteProductsService

    attr_reader :shop_id, :products, :next_page_url

    def initialize shop_id:, products:, next_page_url:
        @shop_id = shop_id
        @products = products
        @next_page_url = next_page_url
    end

    def execute    
        create_products
        GetProductsJob.perform_later(shop_id: self.shop_id, current_page_url: next_page_url)
        SyncProductsCompleteJob.perform_later(shop_id: self.shop_id) if !self.next_page_url.present?
    end

    private

    # REFACTOR
    def create_products
        # time = Benchmark.measure {
            self.products["products"].each do |product|
                @product = Product.create!(
                    title: product["title"],
                    shopify_product_id: product["id"],
                    shop_id: self.shop_id
                )
                create_variants(@product.id, product["variants"])
            end
        # }
        # Rails.logger.info "\n\nBENCHMARK TO WRITE PRODUCTS: #{time.real}\n\n"
    end

    def create_variants(product_id, variants)
        variants.each do |variant|
            # binding.pry
            Variant.create!(
                sku: variant["sku"],
                quantity: variant["inventory_quantity"],
                shopify_variant_id: variant["id"],
                product_id: product_id,
                local_threshold: nil,
                shop_id: self.shop_id
            )
        end
    end

end