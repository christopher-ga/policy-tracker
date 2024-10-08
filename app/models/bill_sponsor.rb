class BillSponsor < ApplicationRecord
  belongs_to :bill
  belongs_to :sponsor
end
