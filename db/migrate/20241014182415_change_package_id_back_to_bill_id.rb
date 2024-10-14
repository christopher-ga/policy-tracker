class ChangePackageIdBackToBillId < ActiveRecord::Migration[7.1]
  def change
    def change
      rename_column :user_saved_bills, :package_id, :bill_id
    end
  end
end
