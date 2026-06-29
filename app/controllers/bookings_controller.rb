class BookingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookings = current_user.bookings.includes(show: [:movie, :screen])
  end

  def show
    @booking = current_user.bookings.find_by(id: params[:id])

    if @booking.nil?
      redirect_to bookings_path, alert: "Booking receipt not found or access denied."
    end
  end

  def create
    show_id = params[:show_id]
    seat_ids = Array(params[:seat_ids]).flatten.compact_blank

    if seat_ids.empty?
      redirect_to show_path(show_id), alert: "No seats were selected."
      return
    end

    Booking.transaction do
      @show = Show.lock("FOR UPDATE").find(show_id)

      already_booked = BookingSeat.joins(:booking).where(bookings: { show_id: show_id }, seat_id: seat_ids).exists?

      if already_booked
        redirect_to show_path(show_id), alert: "One or more selected seats have already been sold."
        raise ActiveRecord::Rollback
      end

      @booking = current_user.bookings.new(
        show_id: show_id,
        total_tickets: seat_ids.count,
        total_amount: (seat_ids.count * @show.ticket_price),
        payment_status: "paid",
        booking_status: "confirmed",
        booking_reference: "RES-#{SecureRandom.hex(4).upcase}"
      )
      @booking.booked_at = Time.current

      if @booking.save
        seat_ids.each do |sid|
          @booking.booking_seats.create!(seat_id: sid)

          ActionCable.server.broadcast("show_#{show_id}_channel", {
            action: "seat_updated",
            status: "booked",
            showtime_seat_id: sid,
            locked_by_id: nil
          })
        end

        SeatLock.where(show_id: show_id, seat_id: seat_ids).destroy_all

        redirect_to booking_path(@booking), notice: "Tickets successfully booked!"
      else
        redirect_to show_path(show_id), alert: "Unable to process booking. Please try again."
      end
    end
  rescue ActiveRecord::Rollback

  end
end