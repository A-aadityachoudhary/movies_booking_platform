class SeatLocksController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource except: [:create_multiple]

    def create_multiple
        show_id = params[:show_id]
        seat_ids = params[:seat_ids]

        if seat_ids.blank?
            redirect_to show_path(show_id), alert: "Please select at least one seat checkbox."
            return
        end

        success_locks = []

        SeatLock.transaction do
            
            Show.lock("FOR UPDATE").find(show_id)

            seat_ids.each do |seat_id|
                seat = Seat.find(seat_id)

                already_locked = SeatLock.active.exists?(show_id: show_id, seat_id: seat.id)
                already_booked = BookingSeat.joins(:booking).exists?(bookings: { show_id: show_id }, seat_id: seat.id)

                if already_locked || already_booked
                    redirect_to show_path(show_id), alert: "already booked"
                    raise ActiveRecord::Rollback 
                end

                lock = current_user.seat_locks.new(show_id: show_id, seat_id: seat.id)
                lock.expires_at = 1.minutes.from_now

                if lock.save
                    success_locks << lock
                else
                    redirect_to show_path(show_id), alert: "Unable to hold some of your seat selections."
                    raise ActiveRecord::Rollback
                end
            end
        end

        if success_locks.any?
            success_locks.each do |lock|
                ReleaseSeatLockJob.set(wait: 1.minutes).perform_later(lock.id)

                ActionCable.server.broadcast(
                    "show_#{show_id}_channel", 
                    { action: "locked", seat_id: lock.seat_id }
                )
            end

            redirect_to show_path(show_id), notice: "#{success_locks.count} seats successfully held for 5 minutes!"
        end
    end

    def destroy
        @seat_lock = current_user.seat_locks.find(params[:id])
        show_id = @seat_lock.show_id
        @seat_lock.destroy

        ActionCable.server.broadcast(
            "show_#{show_id}_channel", 
            { action: "released", seat_id: @seat_lock.seat_id }
        )

        redirect_to show_path(show_id), notice: "Seat reservation released."
    end
end
