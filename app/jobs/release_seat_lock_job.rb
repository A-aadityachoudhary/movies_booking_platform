class ReleaseSeatLockJob < ApplicationJob
  queue_as :default

  def perform(seat_lock_id)
    seat_lock = SeatLock.find_by(id: seat_lock_id)
    return unless seat_lock
    show_id = seat_lock.show_id
    seat_id = seat_lock.seat_id
    seat_lock.destroy
    ActionCable.server.broadcast(
      "show_#{show_id}_channel",
      {action: "released", seat_id: seat_id}
    )
  end
end
