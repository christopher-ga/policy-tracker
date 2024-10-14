class ModifyBillsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :package_id, :string
    add_column :bills, :date_issued, :date
    add_column :bills, :short_title, :string
    add_column :bills, :bill_number, :string
    add_column :bills, :latest_action_date, :date
    add_column :bills, :latest_action_text, :text

    remove_column :bills, :sponsor_first_name, :string
    remove_column :bills, :sponsor_last_name, :string
    remove_column :bills, :sponsor_party, :string
    remove_column :bills, :sponsor_state, :string
    remove_column :bills, :sponsor_url, :string

    remove_column :bills, :introduced_date, :string
    remove_column :bills, :sponsor_url, :string
    remove_column :bills, :bill_url, :string
  end
end
