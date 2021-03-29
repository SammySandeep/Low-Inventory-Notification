class AddShopIdToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :shop_id, :integer
    add_index :variants, :shop_id
  end
end
