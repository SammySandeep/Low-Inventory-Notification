class Variant < ApplicationRecord
    
    belongs_to :product
    belongs_to :shop
    
    validates :quantity, numericality: { only_integer: true }, presence: true
    validates :shopify_variant_id, presence: true, uniqueness: true
    validates :local_threshold, numericality: { only_integer: true }, presence: true, allow_nil: true

    def threshold
        if self.local_threshold.present?
            self.local_threshold
        else
            self.product.shop.shop_setting.global_threshold
        end
    end

    def self.update_local_threshold_from_csv csv_file_path
        ActiveRecord::Base.connection.execute(
            "BEGIN TRANSACTION;
            
            CREATE TEMP TABLE temp_csv_table(
                variant_id TEXT,
                product_title TEXT,
                sku TEXT,
                local_threshold INT
            );
            
            COPY temp_csv_table
            FROM '#{csv_file_path}'
            DELIMITER ','
            CSV HEADER;
            
            UPDATE variants
            SET local_threshold = temp_csv_table.local_threshold
            FROM temp_csv_table
            WHERE variants.shopify_variant_id = TRIM(LEADING '#' FROM temp_csv_table.variant_id)::BIGINT;

            DROP TABLE temp_csv_table;
            
            COMMIT TRANSACTION;"
        )
    end

    def self.write_variants_from_shopify_products_json shop_id:, shopify_products_json:
        ActiveRecord::Base.connection.execute(
            "BEGIN TRANSACTION;
            
            INSERT INTO variants (shop_id, shopify_variant_id, sku, quantity, product_id, created_at, updated_at)
            SELECT #{shop_id}, shopify_variant_id, sku, quantity, product_id, created_at, updated_at FROM
            (
                SELECT
                    (json_array_elements(products_json -> 'variants') ->> 'id')::BIGINT AS shopify_variant_id,
                    json_array_elements(products_json -> 'variants') ->> 'product_id' AS shopify_product_id,
                    json_array_elements(products_json -> 'variants') ->> 'sku' AS sku,
                    (json_array_elements(products_json -> 'variants') ->> 'inventory_quantity')::INTEGER AS quantity,
                    (SELECT id FROM products WHERE shopify_product_id = shopify_product_id LIMIT 1) AS product_id,
                    timezone('utc', now()) AS created_at,
                    timezone('utc', now()) AS updated_at
                FROM json_array_elements(
                $$
                #{shopify_products_json}
                $$::json) AS products_json
            ) AS variants_json;
            
            COMMIT TRANSACTION;"
        )
    end

end
