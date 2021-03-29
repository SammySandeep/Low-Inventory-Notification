class WriteProductsJob < ApplicationJob
    queue_as :default

    def perform(shop, products, next_link)
        Sync::WriteProducts.new(shop, products, next_link).execute
    end
end