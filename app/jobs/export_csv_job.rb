class ExportCsvJob < ApplicationJob
    queue_as :default
    include ApplicationHelper

    def perform(shop, sql_statement)
        file = Csv::Generate.new(shop, sql_statement).execute()
        session_activate shop
        shop = ShopifyAPI::Shop.current
        NotificationMailer.export_csv(shop.email, file).deliver!
    end
    
end