class SavedBill < ApplicationRecord
  belongs_to :user
  belongs_to :bill
end
