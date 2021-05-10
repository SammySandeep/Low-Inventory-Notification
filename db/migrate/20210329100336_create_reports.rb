class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :file_name
      t.integer :shop_id
      t.timestamps
    end

    add_index :reports, :shop_id
  end
end
