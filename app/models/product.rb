class Product < ApplicationRecord

    belongs_to :shop
    
    has_many :variants

    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true

    def self.write_products_from_shopify_products_json shop_id:, shopify_products_json:
        ActiveRecord::Base.connection.execute(
            <<-SQL
                BEGIN TRANSACTION;
                
                INSERT INTO products (title, shopify_product_id, shop_id, created_at, updated_at)
                SELECT
                    products_json ->> 'title' AS title,
                    (products_json ->> 'id')::BIGINT AS shopify_product_id,
                    #{shop_id} AS shop_id,
                    timezone('utc', now()) AS created_at,
                    timezone('utc', now()) AS updated_at
                FROM json_array_elements(
                $$
                #{shopify_products_json}
                $$::json) AS products_json;
                
                COMMIT TRANSACTION;
            SQL
        )

    end

end
