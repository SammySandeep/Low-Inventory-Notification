class Sync::GetProducts

  attr_reader :shop, :next_page


  def initialize(shop, next_page)
      @shop = shop
      @next_page = next_page
  end

  def execute
      headers = headers()
      products_url_with_limit = products_url_with_limit()
      if self.next_page == "first page"
          products = get_products(products_url_with_limit, headers)
          if products.headers["link"] == nil 
            next_link = ""
          else 
            next_link = alter_next_link(products.headers["link"])
          end  
          write_products(products, next_link)
          get_products_if_link_present(products, next_link)
      elsif self.next_page != ""
          products = get_products(self.next_page, headers)
          next_link = alter_next_link(products.headers["link"])
          write_products(products, next_link)
          get_products_if_link_present(products, next_link)
      end

  end
  
  private

  def get_products_if_link_present products, next_link
      if next_link != ""
          GetProductsJob.perform_later(self.shop, next_link)
      end
  end

  def get_products(url, headers)
      HTTParty.get(url, headers: headers)
  end

  def write_products(products, next_link)
      WriteProductsJob.perform_later(self.shop, products.to_h, next_link)
  end

  def alter_next_link(link)
      next_url = String.new
      links = link.split(',')
          links.each do |link|
              parts = link.split('; ')
              url = parts[0][/<(.*)>/, 1]
              rel = parts[1][/rel="(.*)"/, 1]
              if rel == "next"
                  next_url = url
              end
          end
      return  next_url
  end

  def headers
      { "X-Shopify-Access-Token": self.shop.shopify_token }
  end

  def products_url_with_limit
      "https://#{self.shop.shopify_domain}/admin/api/2020-04/products.json?limit=250"
  end

end
