class BookingsController < ApplicationController
    before_action :authenticate_user!
    def index
        @bookings = current_user.bookings.includes(:show)
    end
    def show
        @booking = current_user.bookings.find(params[:id])
    end
    def create
        @active_locks = current_user.seat_locks.active.where(show_id: booking_params[:show_id])
        if @active_locks.empty?
            redirect_to show_path(booking_params[:show_id]), alert: "Your seat holds have expired or you haven't selected any seats."
            return
        end
        Booking.transaction do
            @show = Show.lock.find(booking_params[:show_id])
            @booking = current_user.bookings.new(booking_params)
            @booking.booked_at = Time.current
            @booking.total_tickets = @active_locks.count
            if @booking.save
                @active_locks.each do |lock|
                    @booking.booking_seats.create!(seat_id: lock.seat_id)
                end
                @active_locks.destroy_all
                redirect_to booking_path(@booking), notice: "Booking confirmed"
            else
                redirect_to bookings_path, alert: "booking not confirmed"
            end
        end
    end
    rescue ActiveRecord::RecordInvalid => e
        redirect_to show_path(booking_params[:show_id]), alert: "An item processing failure occurred. Please retry."
    end
    private
    def booking_params
        params.require(:booking).permit(:show_id, :total_tickets, :total_amount, :payment_status, :booking_status, :booking_reference)
    end
end
