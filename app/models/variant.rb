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

    def self.write_variants_from_shopify_products_json shop_id:, shopify_products_json:
        ActiveRecord::Base.connection.execute(
            <<-SQL
                BEGIN TRANSACTION;
                
                INSERT INTO variants (shop_id, product_id, shopify_variant_id, sku, quantity, created_at, updated_at)
                SELECT 
                    #{shop_id} AS shop_id, 
                    (SELECT id FROM products WHERE products.shopify_product_id = variants_json.shopify_product_id LIMIT 1) AS product_id, 
                    shopify_variant_id, sku, quantity, created_at, updated_at 
                FROM
                (
                    SELECT
                        (json_array_elements(products_json -> 'variants') ->> 'id')::BIGINT AS shopify_variant_id,
                        (json_array_elements(products_json -> 'variants') ->> 'product_id')::BIGINT AS shopify_product_id,
                        json_array_elements(products_json -> 'variants') ->> 'sku' AS sku,
                        (json_array_elements(products_json -> 'variants') ->> 'inventory_quantity')::INTEGER AS quantity,
                        timezone('utc', now()) AS created_at,
                        timezone('utc', now()) AS updated_at
                    FROM json_array_elements(
                    $$
                    #{shopify_products_json}
                    $$::json) AS products_json
                ) AS variants_json;

                COMMIT TRANSACTION;
            SQL
        )
    end

    # Certain versions of excel changes format of big numbers. Eg: 32274860376127 to 3227+e1
    # Prepending shopify_variant_id and sku with # converts it to text and preserves the number
    # Since this method is used ONLY to export products to csv, this change has been made
    def self.export_variants_data_to_csv shop_id:
        ActiveRecord::Base.connection.execute(
            <<-SQL
                SELECT  
                    CONCAT('#', variants.shopify_variant_id) AS id, 
                    products.title AS title, 
                    CONCAT('#', variants.sku) AS sku, 
                    variants.quantity AS quantity, 
                    COALESCE(variants.local_threshold, shop_settings.global_threshold) AS threshold
                FROM variants
                INNER JOIN products ON variants.product_id = products.id 
                INNER JOIN shops ON products.shop_id = shops.id
                INNER JOIN shop_settings ON shop_settings.shop_id = shops.id
                WHERE products.shop_id = #{shop_id};
            SQL
        )
    end

    def self.update_local_threshold_from_csv shop_id:, csv_json:
        ActiveRecord::Base.connection.execute(
            <<-SQL
                BEGIN TRANSACTION;
                
                WITH variants_csv_table AS (
                    SELECT 
                        TRIM(LEADING '#' FROM variants_csv."Variant ID")::BIGINT as shopify_variant_id,
                        (variants_csv."Threshold")::INT AS threshold
                    FROM json_populate_recordset(
                        null::record,
                        $$
                        #{csv_json}
                        $$
                    ) AS variants_csv
                    (
                        "Variant ID" TEXT,
                        "Threshold" TEXT
                    )
                )
                
                UPDATE variants
                SET local_threshold = (
                    CASE 
                        WHEN variants_csv_table.threshold = (SELECT global_threshold FROM shop_settings WHERE shop_settings.shop_id=#{shop_id} LIMIT 1)
                        THEN NULL
                        ELSE variants_csv_table.threshold
                    END),
                    updated_at = timezone('utc', now())
                FROM variants_csv_table
                WHERE variants.shopify_variant_id = variants_csv_table.shopify_variant_id;
                
                COMMIT TRANSACTION;
            SQL
        )
    end

    def self.get_low_inventory_variants shop_id:
        ActiveRecord::Base.connection.execute(
            <<-SQL
                SELECT
                    STRING_AGG (
                        CONCAT('#', shopify_variant_id) 
                        || ',' || 
                        REPLACE(REPLACE(title, ',', ' '), '\n', ' ')
                        || ',' || 
                        CONCAT('#', sku) 
                        || ',' || 
                        threshold,
                        '\n'
                    ) 
                AS variants_csv
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
                WHERE shopify_variant_id IS NOT NULL;
            SQL
        )
    end
        
end
