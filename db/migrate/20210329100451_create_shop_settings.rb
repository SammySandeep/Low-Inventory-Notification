class CreateShopSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_settings do |t|
      t.integer :global_threshold
      t.integer :alert_frequency
      t.integer :shop_id
      t.timestamps
    end

    add_index :shop_settings, :shop_id
  end
end
