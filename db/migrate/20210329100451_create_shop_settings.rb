class CreateShopSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_settings do |t|
      t.integer :global_threshold
      t.integer :alert_frequency
      t.references :shop, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
