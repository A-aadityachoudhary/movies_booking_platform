class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :show
  has_many :booking_seats, dependent: :destroy
  has_many :seats, through: :booking_seats
  has_one :payment, dependent: :destroy
  enum :booking_status, {pending: 0, confirmed: 1, failed: 2, cancelled: 3}, default: :pending
  validates :total_amount, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :booking_status, presence: true
end
