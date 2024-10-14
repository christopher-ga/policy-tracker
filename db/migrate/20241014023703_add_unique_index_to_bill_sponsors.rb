class AddUniqueIndexToBillSponsors < ActiveRecord::Migration[7.1]
  def change
    add_index :bill_sponsors, [:bill_id, :sponsor_id], unique: true

  end
end
