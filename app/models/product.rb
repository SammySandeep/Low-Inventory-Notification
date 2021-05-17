class Product < ApplicationRecord

    has_many :variants, dependent: :destroy

    belongs_to :shop

    validates :title, presence: true
    validates :shopify_product_id, presence: true, uniqueness: true

    # REFACTOR - method name
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

end
