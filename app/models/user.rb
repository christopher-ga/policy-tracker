class User < ApplicationRecord
  has_secure_password

  has_many :user_saved_bills
  has_many :bills, through: :user_saved_bills

  validates :email, presence: true,
            format: { with: /\S+@\S+/ },
            uniqueness: { case_sensitive: false }


  has_many :user_bill_views
  has_many :viewed_bills, through: :user_bill_views, source: :bill
end
