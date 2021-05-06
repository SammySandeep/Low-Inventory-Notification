class GenerateReportService

    attr_reader :shop_id, :products

    def initialize shop_id:, products:
        @shop_id = shop_id
        @products = products
    end

    def execute
        DigitalOcean::Spaces::UploadFileService.new(file_name: file_name, file_contents: csv_string, path: "reports/#{shop_name}").execute
    end

    private

    # REFACTOR
    def csv_string
        csv_headers = ["Variant ID", "Product Title", "SKU", "Threshold"]

        csv_string = CSV.generate(write_headers: true, headers: csv_headers) do |csv|
            self.products.each { |csv_row| csv << csv_row }
        end

        return csv_string
    end

    def file_name
        "#{Time.now.utc.to_formatted_s(:number)}_#{shop_name}.csv"
    end

    def shop_name
        Shop.find(self.shop_id).shopify_domain.split(".")[0]
    end

end