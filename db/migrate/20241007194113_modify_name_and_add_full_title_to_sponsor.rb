class ModifyNameAndAddFullTitleToSponsor < ActiveRecord::Migration[7.1]
  def change
    rename_column :sponsors, :name, :first_name
    add_column :sponsors, :full_title, :string
  end
end
