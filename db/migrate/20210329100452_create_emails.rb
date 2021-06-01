class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.text :email, unique: true, null: false
      t.boolean :is_active, default: true
      t.references :shop_setting, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
