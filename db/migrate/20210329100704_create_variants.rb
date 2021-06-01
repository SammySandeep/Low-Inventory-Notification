class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.string :sku
      t.integer :quantity, null: false
      t.bigint :shopify_variant_id, null: false
      t.integer :local_threshold
      t.references :product, foreign_key: {on_delete: :cascade}
      t.references :shop, foreign_key: {on_delete: :cascade}
      t.timestamps
    end

    add_index :variants, :sku
    add_index :variants, :shopify_variant_id
  end
end
