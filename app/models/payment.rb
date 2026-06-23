class Payment < ApplicationRecord
  belongs_to :booking
  has_one :user, through: :booking
end
