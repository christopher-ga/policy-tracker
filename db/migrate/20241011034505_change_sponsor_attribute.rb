class ChangeSponsorAttribute < ActiveRecord::Migration[7.1]
  def change
    rename_column :sponsors, :bioguide_id, :bio_guide_id
  end
end
