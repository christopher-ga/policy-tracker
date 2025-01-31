class CreateUserSavedBills < ActiveRecord::Migration[7.1]
  def change
    create_table :user_saved_bills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
