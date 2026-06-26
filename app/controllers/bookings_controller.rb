class BookingsController < ApplicationController
    before_action :authenticate_user!
    def index
        @bookings = current_user.bookings.includes(:show)
    end
    def show
        @booking = current_user.bookings.find(params[:id])
    end
    def create
        @booking = current_user.bookings.new(booking_params)
        @booking.booked_at = Time.current
        if @booking.save
            redirect_to booking_path(@booking), notice: "Booking confirmed"
        else
            redirect_to bookings_path, alert: "booking not confirmed"
        end
    end
    private
    def booking_params
        params.require(:booking).permit(:show_id, :total_tickets, :total_amount, :payment_status, :booking_status, :booking_reference)
    end
end
