class CreateUserBillViews < ActiveRecord::Migration[7.1]
  def change
    create_table :user_bill_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bill, null: false, foreign_key: true
      t.datetime :last_viewed_at

      t.timestamps
    end
  end
end
