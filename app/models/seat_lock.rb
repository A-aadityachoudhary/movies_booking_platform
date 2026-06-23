class SeatLock < ApplicationRecord
  belongs_to :user
  belongs_to :show
  belongs_to :seat
end
