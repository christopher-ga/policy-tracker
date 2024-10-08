class Sponsor < ApplicationRecord
  has_many :bill_sponsors
  has_many :bills, through: :bill_sponsors




end
