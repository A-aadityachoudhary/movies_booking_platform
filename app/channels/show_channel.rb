class ShowChannel < ApplicationCable::Channel
  def subscribed
    stream_from "show_#{params[:show_id]}_channel" if params[:show_id].present?
  end

  def unsubscribed
  
  end

  def toggle_seat(data)
    seat_id = data["showtime_seat_id"]
    selected = data["selected"]
    show_id = params[:show_id]
    show = Show.find_by(id: show_id)

    return unless show && seat_id

    seat = Seat.find_by(id: seat_id)
    return unless seat

    if selected
      SeatLock.transaction do
        Show.lock("FOR UPDATE").find(show_id)

        already_locked = SeatLock.active.where.not(user_id: current_user.id).exists?(show_id: show_id, seat_id: seat_id)
        already_booked = BookingSeat.joins(:booking).exists?(bookings: { show_id: show_id }, seat_id: seat_id)

        if already_locked || already_booked
          transmit(action: "lock_failed", showtime_seat_id: seat_id, user_id: current_user.id)
          return
        end

        lock = current_user.seat_locks.find_or_initialize_by(show_id: show_id, seat_id: seat_id)
        lock.expires_at = 1.minute.from_now

        if lock.save
          ::ReleaseSeatLockJob.set(wait: 1.minute).perform_later(lock.id, lock.updated_at.to_i)
          
          ActionCable.server.broadcast("show_#{show_id}_channel", {
            action: "seat_updated",
            status: "locked",
            showtime_seat_id: seat_id,
            locked_by_id: current_user.id,
            locked_at: lock.updated_at.iso8601
          })
        end
      end
    else
      lock = current_user.seat_locks.active.find_by(show_id: show_id, seat_id: seat_id)
      if lock&.destroy
        ActionCable.server.broadcast("show_#{show_id}_channel", {
          action: "seat_updated",
          status: "available",
          showtime_seat_id: seat_id,
          locked_by_id: nil
        })
      end
    end
  end
end