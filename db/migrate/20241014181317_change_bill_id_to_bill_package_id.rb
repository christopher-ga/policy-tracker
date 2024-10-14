class ChangeBillIdToBillPackageId < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_saved_bills, :bill_id, :package_id
  end
end
