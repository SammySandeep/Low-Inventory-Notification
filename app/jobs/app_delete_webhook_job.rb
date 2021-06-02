class AppDeleteWebhookJob < ApplicationJob
    queue_as :default

    def perform shopify_domain
        @shop = Shop.find_by_shopify_domain(shopify_domain)

        # DELETE REPORTS
        shop_name = @shop.shopify_domain.split(".")[0]
        @shop.reports.each { |report| DigitalOcean::Spaces::DeleteFileService.new(path: "lina/reports/#{shop_name}", file_name: report.file_name) }

        # DESTROY SHOP
        @shop.destroy
    end

end
