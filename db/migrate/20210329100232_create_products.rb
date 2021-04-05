class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :title
      t.bigint :shopify_product_id
      t.integer :shop_id
      t.timestamps
    end

    add_index :products, :shopify_product_id
    add_index :products, :shop_id
  end
end
