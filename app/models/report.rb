class Report < ApplicationRecord
    belongs_to :shop

    def file_url
        "https://#{ENV["DO_SPACE_NAME"]}.#{ENV["DO_SPACES_CDN_ENDPOINT"]}/reports/#{self.shop_name}/#{self.file_name}"
    end

    private

    def shop_name
        self.shop.shopify_domain.split(".myshopify.com")[0]
    end

end
