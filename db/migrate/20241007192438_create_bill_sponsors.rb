class CreateBillSponsors < ActiveRecord::Migration[7.1]
  def change
    create_table :bill_sponsors do |t|
      t.references :bill, null: false, foreign_key: true
      t.references :sponsor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
