class SeatLock < ApplicationRecord
  belongs_to :user
  belongs_to :show
  belongs_to :seat
  validates :expires_at, presence: true
  scope :active, ->{where('expires_at > ?',Time.current)}
  def expired?
    expires_at < Time.current
  end
end
