class SeatLocksController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource
    def create
        @seat_lock = current_user.seat_locks.new(seat_lock_param)
        @seat_lock.expires_at = 10.minutes.from_now
        if @seat_lock.save
            redirect_to show_path(@seat_lock.show_id), notice: "seat is locked"
        else
            redirect_to show_path(params[:seat_lock][:show_id]), alert: "can't lock the seat"
        end
    end
    def  destroy
        @seat_lock = current_user.seat_locks.find(params[:id])
        show_id = @seat_lock.show_id
        @seat_lock.destroy
        redirect_to show_path(show_id), notice:"seat destroy"
    end
    private
    def seat_lock_param
        params.require(:seat_lock).permit(:show_id, :seat_id)
    end
end
