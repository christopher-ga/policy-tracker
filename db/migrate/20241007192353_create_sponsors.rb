class CreateSponsors < ActiveRecord::Migration[7.1]
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :party
      t.string :state
      t.string :last_name
      t.string :member_type
      t.string :bioguide_id
      t.string :image_url

      t.timestamps
    end
  end
end
