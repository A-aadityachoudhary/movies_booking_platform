class Screen < ApplicationRecord
  belongs_to :theater
  has_many :seats, dependent: :destroy
  has_many :shows, dependent: :destroy
  has_many :seat_locks, through: :shows
end
