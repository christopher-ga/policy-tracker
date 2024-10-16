class Bill < ApplicationRecord
  has_many :user_saved_bills
  has_many :users, through: :user_saved_bills
  has_many :bill_sponsors
  has_many :sponsors, through: :bill_sponsors

  has_many :user_bill_views
  has_many :viewers, through: :user_bill_views, source: :user
end
