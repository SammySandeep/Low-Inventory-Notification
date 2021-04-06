class Csv::Report
    attr_reader :shopify_domain, :products

    def initialize(shopify_domain, products)
        @shopify_domain = shopify_domain
        @products = products
    end

    def execute
        csv_string = generate_csv()
        binding.pry
        
    end

    private

    def generate_csv
        csv_headers = ["Variant ID", "Product Title", "SKU", "Threshold"]

        csv_string = CSV.generate(write_headers: true, headers: csv_headers) do |csv|
            self.products.each do |csv_row|
                csv << csv_row
            end
        end

        return csv_string
    end


end