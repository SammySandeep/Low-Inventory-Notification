class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :file_name, null: false
      t.references :shop, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
