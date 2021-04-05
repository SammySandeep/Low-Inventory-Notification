class Csv::Generate
    attr_reader :shop, :sql_statement
    HEADERS = ["Variant ID", "Product Title", "SKU", "Threshold"]
    def initialize(shop, sql_statement)
        @shop = shop
        @sql_statement = sql_statement
    end

    def execute
        generate_csv(get_variants())
    end

    private

    def generate_csv data
        file = "#{Rails.root}/public/#{self.shop.shopify_domain}-#{Time.now.to_s}.csv"

        CSV.open(file, 'w', write_headers: true, headers: HEADERS) do |writer|
             data.each do |d| 
                binding.pry
                writer << [d["id"], d["title"], d["sku"], d["threshold"]] 
             end
        end
        
        return file
    end

    def get_variants
        ActiveRecord::Base.connection.execute(self.sql_statement)
    end

end
