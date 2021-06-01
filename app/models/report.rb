class Report < ApplicationRecord
    
    belongs_to :shop

    validates :file_name, presence: true

    def file_url
        "https://#{ENV["DO_SPACE_NAME"]}.#{ENV["DO_SPACES_CDN_ENDPOINT"]}/reports/#{self.shop_name}/#{self.file_name}"
    end
    
    def created_at
        attributes['created_at'].strftime("%d %m %Y  %H:%M:%S")
    end

    private

    def shop_name
        self.shop.shopify_domain.split(".myshopify.com")[0]
    end

end
