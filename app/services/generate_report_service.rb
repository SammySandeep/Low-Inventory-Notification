class GenerateReportService

    attr_reader :shop_id, :products

    def initialize shop_id:, products:
        @shop_id = shop_id
        @products = products
    end

    def execute
        file = generate_csv_file()
        target_obj = Aws::S3::UploadFileService.new(file: file).execute
        File.delete("#{Rails.root}/#{file}")
        return target_obj
    end

    private


    def generate_csv_file
        csv_headers = ["Variant ID", "Product Title", "SKU", "Threshold"]
        # file = "#{self.shop.shopify_domain}-#{Time.now.to_s}.csv"

        file = "#{Time.now.utc.to_formatted_s(:number)}_#{shop_name}.csv"

        CSV.open(file, "wb", write_headers: true, headers: csv_headers) do |csv|
            self.products.each do |csv_row|
                csv << csv_row
            end
        end 

        return file
    end

    def shop_name
        Shop.find(self.shop_id).shopify_domain.split(".")[0]
    end

end