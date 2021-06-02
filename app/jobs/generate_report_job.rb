class GenerateReportJob < ApplicationJob
    include ShopifyModule

    queue_as :default

    def perform shop_id:, products:
        @shop = Shop.find(shop_id)
        
        shop_name = @shop.shopify_domain.split(".")[0]
        file_name = "#{Time.now.utc.to_formatted_s(:number)}_#{shop_name}.csv"

        # upload csv and create report
        DigitalOcean::Spaces::UploadFileService.new(file_name: file_name, file_contents: products, path: "lina/reports/#{shop_name}").execute
        @report = Report.create!(shop_id: shop_id, file_name: file_name)

        # notify
        cc_emails = @shop.shop_setting.emails.where(is_active: true).join(",")
        SendReportMailer.notify(to: @shop.admin_email, cc: cc_emails, report_id: @report.id).deliver_later
    end
end