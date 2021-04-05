class Product < ApplicationRecord

    has_many :variants, dependent: :destroy

    belongs_to :shop

    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true

    def self.export_products_data_to_csv shop_id:
        ActiveRecord::Base.connection.execute(
            "SELECT  
                variants.shopify_variant_id AS id, 
                products.title AS title, 
                variants.sku AS sku, 
                variants.threshold AS threshold 
            FROM products 
            INNER JOIN variants ON variants.product_id=products.id 
            WHERE products.shop_id = #{shop_id}"
        )
    end

end
