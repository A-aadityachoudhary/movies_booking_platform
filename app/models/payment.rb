class Payment < ApplicationRecord
  belongs_to :booking
  has_one :user, through: :booking
  enum :status, {pending: 0, successfull: 1, failed: 2}, default: :pending
  validates :amount, presence:true, numericality: {greater_than: 0}
end
