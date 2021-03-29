class GetProductsJob < ApplicationJob
    queue_as :default

    def perform(shop, next_page)
        Sync::GetProducts.new(shop, next_page).execute
    end
end