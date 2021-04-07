class GenerateReportJob < ApplicationJob
    include ShopifyModule

    queue_as :default

    def perform(shop, products)
        target_obj = Csv::GenerateReport.new(shop, products).execute()
        Report.create_report(target_obj, shop)
        recipients = [] 

        shop.shop_setting.emails.each do |email|
            if email.is_active?
                recipients << email.email
            end
        end

        activate_session shop_id: shop.id
        shop = ShopifyAPI::Shop.current
        SendReportMailer.notify(admin: shop.email, recipients: recipients, target_obj_key: target_obj.key).deliver_later
    end
    
end