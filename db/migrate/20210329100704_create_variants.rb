class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.string :sku
      t.integer :quantity
      t.bigint :shopify_variant_id
      t.integer :local_threshold
      t.integer :product_id
      t.integer :shop_id
      t.timestamps
    end

    add_index :variants, :sku
    add_index :variants, :shopify_variant_id
    add_index :variants, :product_id
    add_index :variants, :shop_id
  end
end
