class Csv::GenerateReport
    attr_reader :shop, :products

    def initialize(shop, products)
        @shop = shop
        @products = products
    end

    def execute
        file = generate_csv()
        target_obj = Aws::S3::UploadCsv.new(file).execute
        File.delete("#{Rails.root}/#{file}")
        return target_obj
    end

    private


    def generate_csv
        csv_headers = ["Variant ID", "Product Title", "SKU", "Threshold"]
        file = "#{self.shop.shopify_domain}-#{Time.now.to_s}.csv"

        CSV.open(file, "wb", write_headers: true, headers: csv_headers) do |csv|
            self.products.each do |csv_row|
                csv << csv_row
            end
        end 

        return file
    end


end