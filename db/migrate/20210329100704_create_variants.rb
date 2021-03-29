class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.string :sku
      t.integer :quantity
      t.bigint :shopify_variant_id
      t.integer :threshold
      t.integer :product_id
      t.timestamps
    end
  end
end
