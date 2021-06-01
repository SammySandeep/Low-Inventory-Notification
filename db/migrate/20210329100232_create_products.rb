class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :title, null: false
      t.bigint :shopify_product_id, null: false
      t.references :shop, foreign_key: {on_delete: :cascade}
      t.timestamps
    end

    add_index :products, :shopify_product_id
  end
end
