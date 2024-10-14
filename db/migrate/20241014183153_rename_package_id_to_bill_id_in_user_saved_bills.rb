class RenamePackageIdToBillIdInUserSavedBills < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_saved_bills, :package_id, :bill_id
  end
end
