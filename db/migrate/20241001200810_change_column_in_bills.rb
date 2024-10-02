class ChangeColumnInBills < ActiveRecord::Migration[7.1]
  def change
    rename_column :bills, :type, :bill_type
  end
end
