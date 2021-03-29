class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :email
      t.boolean :is_admin, default: false
      t.boolean :is_active, default: false
      t.integer :shop_setting
      t.timestamps
    end
  end
end
