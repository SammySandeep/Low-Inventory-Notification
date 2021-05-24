class ExportCsvJob < ApplicationJob

    include ShopifyModule

    queue_as :default

    def perform shop_id:
        csv_headers = ["Variant ID", "Product Title", "SKU", "Threshold"]
        csv_string = Product.export_products_data_to_csv(shop_id: shop_id).first["products_csv"].prepend("Variant ID,Product Title,SKU,Threshold\n")

        activate_session shop_id: shop_id
        shop = ShopifyAPI::Shop.current

        ExportCsvMailer.notify(email: shop.email, csv_string: csv_string).deliver_later
    end

end