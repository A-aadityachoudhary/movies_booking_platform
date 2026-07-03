class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :bookings, dependent: :destroy
  has_many :seat_locks, dependent: :destroy
  has_many :booking_seats, through: :bookings
  validate :no_on_same_time

  private
  def no_on_same_time
    return unless start_time.present? && end_time.present?
    on_same_time = Show.where(screen_id: screen_id).where.not(id: id).where("start_time <? AND end_time >?", end_time, start_time )
    if on_same_time.exists?
      errors.add(:start_time, "overlaps with an existing movie showtime on this screen.")
    end
  end
end
