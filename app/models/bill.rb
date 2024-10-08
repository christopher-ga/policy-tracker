class Bill < ApplicationRecord
  has_many :user_saved_bills
  has_many :users, through: :user_saved_bills
  has_many :bill_sponsors
  has_many :sponsors, through: :bill_sponsors
end
