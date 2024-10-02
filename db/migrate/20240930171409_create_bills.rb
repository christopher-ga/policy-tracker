class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.string :name
      t.string :status
      t.string :bill_id
      t.string :bill_information

      t.timestamps
    end
  end
end
