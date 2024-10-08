class User < ApplicationRecord
  has_secure_password

  has_many :user_saved_bills
  has_many :bills, through: :user_saved_bills

  validates :email, presence: true,
            format: { with: /\S+@\S+/ },
            uniqueness: { case_sensitive: false }

end
