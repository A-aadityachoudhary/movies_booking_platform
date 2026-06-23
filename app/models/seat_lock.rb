class SeatLock < ApplicationRecord
  belongs_to :user
  belongs_to :show
  belongs_to :seat
  validates :expire_at, presence: true
  scope :active, ->{where('expireds_at > ?',Time.current)}
  def expired?
    expires_at < Time.current
  end
end
