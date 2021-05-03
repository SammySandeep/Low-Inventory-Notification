class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :email, unique: true
      t.boolean :is_active, default: true
      t.integer :shop_setting_id
      t.timestamps
    end

    add_index :emails, :shop_setting_id
  end
end
