class Product < ApplicationRecord

    has_many :variants, dependent: :destroy

    belongs_to :shop

    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true

    # Certain versions of excel changes format of big numbers. Eg: 32274860376127 to 3227+e1
    # Prepending shopify_variant_id and sku with # converts it to text and preserves the number
    # Since this method is used ONLY to export products to csv, this change has been made
    def self.export_products_data_to_csv shop_id:
        ActiveRecord::Base.connection.execute(
            "SELECT  
                CONCAT('#', variants.shopify_variant_id) AS id, 
                products.title AS title, 
                CONCAT('#', variants.sku) AS sku, 
                variants.local_threshold AS threshold
            FROM products 
            INNER JOIN variants ON variants.product_id=products.id 
            WHERE products.shop_id = #{shop_id}"
        )
    end

    def self.write_products_from_shopify_products_json shop_id:, shopify_products_json:
        ActiveRecord::Base.connection.execute(
            "BEGIN TRANSACTION;
            
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
            
            COMMIT TRANSACTION;"
        )

    end

end
