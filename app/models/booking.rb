class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :show
  has_many :booking_seats, dependent: :destroy
  has_many :seats, through: :booking_seats
  has_one :payment, dependent: :destroy
end
