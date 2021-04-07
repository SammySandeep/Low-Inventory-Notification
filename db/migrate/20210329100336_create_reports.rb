class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.text :s3_key
      t.integer :shop_id
      t.timestamps
    end

    add_index :reports, :shop_id
  end
end
