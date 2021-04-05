class Csv::Report
    attr_reader :shopify_domain, :variants

    def initialize(shopify_domain, variants)
        @shopify_domain = shopify_domain
        @variants = variants
    end

    def execute
        generate_csv()
    end

    private

    def generate_csv
        
    end


end