class Sync::GetProductsService

    attr_reader :shop_id, :current_page_url

    def initialize shop_id:, current_page_url:
        @shop_id = shop_id
        @current_page_url = current_page_url
    end

    def execute
        response = HTTParty.get(url, headers: headers)
        if !(response.headers["link"]).nil?
            next_page_url = get_next_page_url(response.headers["link"])
            WriteProductsJob.perform_later(shop_id: self.shop_id, products: response.to_h, next_page_url: next_page_url)
        else
            WriteProductsJob.perform_later(shop_id: self.shop_id, products: response.to_h, next_page_url: nil)
        end
    end

    private

    def get_next_page_url url_string
        if self.current_page_url == "first_page"
            get_url_from_string(url_string)
        else
            previous_page_url_string, next_page_url_string = url_string.split(',')
            if next_page_url_string.present?
                get_url_from_string(next_page_url_string)
            else
                nil
            end
        end
    end

    def get_url_from_string url_string
        url_string.split("<")[1].split(">")[0]
    end

    def headers
        { "X-Shopify-Access-Token": self.shop.shopify_token }
    end

    def url
        self.current_page_url == "first_page" ? first_page_url : self.current_page_url
    end

    def first_page_url
        "https://#{shop.shopify_domain}/admin/api/2020-04/products.json?limit=250"
    end

    def shop
        Shop.find(self.shop_id)
    end

end
