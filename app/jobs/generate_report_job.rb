class GenerateReportJob < ApplicationJob
    include ShopifyModule

    queue_as :default

    def perform shop_id:, products:
        @shop = Shop.find(shop_id)

        # create report
        file_name = GenerateReportService.new(shop_id: shop_id, products: products).execute
        @report = Report.create!(shop_id: shop_id, file_name: file_name)

        # notify
        cc_emails = @shop.shop_setting.emails.where(is_active: true).join(",")
        SendReportMailer.notify(to: @shop.admin_email, cc: cc_emails, report_id: @report.id).deliver_later
    end

end