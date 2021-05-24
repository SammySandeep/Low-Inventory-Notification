class Variant < ApplicationRecord
    
    belongs_to :product
    belongs_to :shop
    
    validates :quantity, numericality: { only_integer: true }, presence: true
    validates :shopify_variant_id, presence: true, uniqueness: true
    validates :local_threshold, numericality: { only_integer: true }, presence: true, allow_nil: true

    def threshold
        ActiveRecord::Base.connection.exec_query(
            "SELECT threshold(#{self.local_threshold || "null"}, #{self.shop.shop_setting.global_threshold})"
        ).rows.flatten.first
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

    def self.get_low_inventory_variants shop_id:
        ActiveRecord::Base.connection.execute(
            "SELECT
                STRING_AGG (
                    CONCAT('#', shopify_variant_id) || ',' || title || ',' || CONCAT('#', sku) || ',' || threshold,
                    '\n'
                ) AS variants_csv
            FROM (
                SELECT 
                CASE WHEN variants.quantity <= threshold(variants.local_threshold, shop_settings.global_threshold) THEN variants.shopify_variant_id END AS shopify_variant_id,
                CASE WHEN variants.quantity <= threshold(variants.local_threshold, shop_settings.global_threshold) THEN products.title END AS title,
                CASE WHEN variants.quantity <= threshold(variants.local_threshold, shop_settings.global_threshold) THEN variants.sku END AS sku,
                CASE WHEN variants.quantity <= threshold(variants.local_threshold, shop_settings.global_threshold) THEN threshold(variants.local_threshold, shop_settings.global_threshold) END AS threshold
                
                FROM variants
                INNER JOIN products ON variants.product_id = products.id
                INNER JOIN shop_settings ON shop_settings.shop_id = #{shop_id}
                WHERE variants.shop_id = #{shop_id} AND shopify_variant_id IS NOT NULL
                ) AS low_inventory_stocks
                WHERE shopify_variant_id IS NOT NULL;"
            )
        end
        
    end
