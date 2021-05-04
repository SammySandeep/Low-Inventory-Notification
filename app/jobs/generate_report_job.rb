class GenerateReportJob < ApplicationJob
    include ShopifyModule

    queue_as :default

    def perform shop_id:, products:
        @shop = Shop.find(shop_id)

        # create report
        target_obj = GenerateReportService.new(shop_id: shop_id, products: products).execute
        Report.create!(shop_id: @shop.id, s3_key: target_obj.key)
        
        activate_session shop_id: shop_id
        shopify_shop_object = ShopifyAPI::Shop.current
        # notify
        recipients = @shop.shop_setting.emails.where(is_active: true)
        SendReportMailer.notify(admin: shopify_shop_object.email, recipients: recipients.to_a, target_obj_key: target_obj.key).deliver_later
    end


end