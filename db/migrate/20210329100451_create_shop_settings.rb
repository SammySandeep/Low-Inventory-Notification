class CreateShopSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_settings do |t|
      t.integer :global_threshold
      t.integer :alert_frequency
      t.integer :shop_id
      t.boolean :sync_complete, default: false
      t.timestamps
    end
  end
end
