class ExportCsvJob < ApplicationJob

    include ShopifyModule

    queue_as :default

    def perform shop_id:
        csv_headers = ["Variant ID", "Product Title", "SKU", "Quantity", "Threshold"]
        csv_data = Variant.export_variants_data_to_csv(shop_id: shop_id).values
    
        csv_string = CSV.generate(write_headers: true, headers: csv_headers) do |csv|
            csv_data.each do |csv_row|
                csv << csv_row
            end
        end
    
        activate_session shop_id: shop_id
        shop = ShopifyAPI::Shop.current
    
        ExportCsvMailer.notify(email: shop.email, csv_string: csv_string).deliver_later
    end

end