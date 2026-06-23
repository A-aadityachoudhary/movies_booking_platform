class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :bookings, dependent: :destroy
  has_many :seat_locks, dependent: :destroy
  has_many :booking_seats, through: :bookings
end
