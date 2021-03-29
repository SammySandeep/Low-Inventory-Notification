class RenameColumnInEmails < ActiveRecord::Migration[5.2]
  def change
    rename_column :emails, :shop_setting, :shop_setting_id
  end
end
