class ModifyBills < ActiveRecord::Migration[7.1]
  def change

    rename_column :bills, :name, :title

    rename_column :bills, :created_at, :introduced_date

    rename_column :bills, :updated_at, :update_date

    add_column :bills, :congress, :string
    add_column :bills, :type, :string
    add_column :bills, :bill_url, :string
    add_column :bills, :latest_action, :string
    add_column :bills, :sponsor_first_name, :string
    add_column :bills, :sponsor_last_name, :string
    add_column :bills, :sponsor_party, :string
    add_column :bills, :sponsor_state, :string
    add_column :bills, :sponsor_url, :text

    remove_column :bills, :status
    remove_column :bills, :bill_information

    #delete status
    # delete bill_information




  end
end
