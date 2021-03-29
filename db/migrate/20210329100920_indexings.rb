class Indexings < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :shopify_product_id
    add_index :products, :shop_id

    add_index :variants, :sku
    add_index :variants, :shopify_variant_id
    add_index :variants, :product_id

    add_index :shop_settings, :shop_id

    add_index :emails, :shop_setting

    add_index :reports, :shop_id
  end
end
