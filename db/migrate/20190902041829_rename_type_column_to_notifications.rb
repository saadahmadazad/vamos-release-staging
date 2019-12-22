class RenameTypeColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :type, :profile
  end
end
