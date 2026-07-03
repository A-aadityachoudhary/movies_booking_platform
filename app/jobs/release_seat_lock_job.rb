class ReleaseSeatLockJob < ApplicationJob
  queue_as :default

  def perform(seat_lock_id, lock_timestamp)
    lock = nil
    did_unlock = false

    ActiveRecord::Base.transaction do
      lock = SeatLock.find_by(id: seat_lock_id)
      next unless lock
      next if lock.updated_at.to_i > lock_timestamp.to_i # Skip if user updated/extended the hold

      lock.destroy
      did_unlock = true
    end

    if did_unlock && lock
      ActionCable.server.broadcast("show_#{lock.show_id}_channel", {
        action: "seat_updated",
        status: "available",
        showtime_seat_id: lock.seat_id,
        locked_by_id: nil
      })
    end
  end
end