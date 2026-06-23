class Seat < ApplicationRecord
  belongs_to :screen
  has_many :booking_seats, dependent: :destroy
  has_many :bookings, through: :booking_seats
  has_many :seat_locks, dependent: :destroy
end
