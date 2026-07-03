# Clear out existing data to prevent duplicate record errors on re-runs
puts "Cleaning database..."
SeatLock.destroy_all
BookingSeat.destroy_all
Payment.destroy_all
Booking.destroy_all
Seat.destroy_all
Show.destroy_all
Screen.destroy_all
Theater.destroy_all
Review.destroy_all
Movie.destroy_all
User.destroy_all

puts "Creating Users (Admin, Theater Owner, Customer)..."

# 1. Users
admin = User.create!(
  first_name: "System",
  last_name: "Admin",
  email: "admin@gmail.com",
  password: "992838",
  password_confirmation: "992838",
  role: :admin
)

owner = User.create!(
  first_name: "John",
  last_name: "TheaterOwner",
  email: "owner@gmail.com",
  password: "992838",
  password_confirmation: "992838",
  role: :theater_owner
)

customer = User.create!(
  first_name: "Alice",
  last_name: "Smith",
  email: "customer@gmail.com",
  password: "992838",
  password_confirmation: "992838",
  role: :customer
)

puts "Creating Movies..."

# 2. Movies
movie_sci_fi = Movie.create!(
  title: "Interstellar Journey",
  description: "A team of explorers travel beyond this galaxy to discover whether mankind has a future among the stars.",
  duration: 169,
  genre: "Sci-Fi",
  language: "English",
  release_date: Date.today - 10,
  status: :active
)

movie_action = Movie.create!(
  title: "Velocity 10",
  description: "High octane action featuring street racers taking down an international crime syndicate.",
  duration: 130,
  genre: "Action",
  language: "English",
  release_date: Date.today - 2,
  status: :active
)

movie_upcoming = Movie.create!(
  title: "Cyberpunk 2088",
  description: "An upcoming look into a dystopian future ruled by megacorporations and cybernetic augmentations.",
  duration: 145,
  genre: "Sci-Fi / Thriller",
  language: "English",
  release_date: Date.today + 30,
  status: :upcoming
)

puts "Creating Theaters, Screens, and Seats..."

# 3. Theaters
theater_grand = Theater.create!(
  user: owner,
  name: "Grand Horizon Cinema",
  description: "Premium cinematic experience with state-of-the-art Dolby Atmos sound.",
  address: "123 Hollywood Blvd",
  city: "Los Angeles",
  state: "California",
  country: "USA",
  contact_number: "555-0199",
  email: "contact@grandhorizon.com",
  status: 1
)

# 4. Screens
screen_one = Screen.create!(
  theater: theater_grand,
  name: "Screen 1 (IMAX)",
  screen_type: 1, # e.g., IMAX / Premium
  total_seats: 30,
  status: 1
)

screen_two = Screen.create!(
  theater: theater_grand,
  name: "Screen 2 (Standard)",
  screen_type: 0, # e.g., Standard
  total_seats: 20,
  status: 1
)

# 5. Seats generation for Screen 1 (3 Rows: A, B, C | 10 seats each)
['A', 'B', 'C'].each do |row|
  (1..10).each do |num|
    Seat.create!(
      screen: screen_one,
      row_name: row,
      seat_number: num,
      category: row == 'C' ? 1 : 0 # e.g., VIP vs Regular
    )
  end
end

# Seats generation for Screen 2 (2 Rows: A, B | 10 seats each)
['A', 'B'].each do |row|
  (1..10).each do |num|
    Seat.create!(
      screen: screen_two,
      row_name: row,
      seat_number: num,
      category: 0
    )
  end
end

puts "Creating Shows..."

# 6. Shows
show_im_1 = Show.create!(
  movie: movie_sci_fi,
  screen: screen_one,
  start_time: Time.current + 2.hours,
  end_time: Time.current + 5.hours,
  ticket_price: 15.50,
  status: 1
)

show_im_2 = Show.create!(
  movie: movie_action,
  screen: screen_two,
  start_time: Time.current + 4.hours,
  end_time: Time.current + 6.hours,
  ticket_price: 12.00,
  status: 1
)

puts "Creating Reviews..."

# 7. Reviews
Review.create!(
  user: customer,
  movie: movie_sci_fi,
  rating: 5,
  comment: "Absolutely mind-bending! Visually stunning and emotionally gripping."
)

puts "Creating Bookings, Booking Seats, and Payments..."

# 8. Bookings
booking = Booking.create!(
  user: customer,
  show: show_im_1,
  booked_at: Time.current - 1.hour,
  booking_reference: "BK-XYZ123",
  booking_status: :confirmed,
  payment_status: 1,
  total_tickets: 2,
  total_amount: 31.00 # 2 tickets * 15.50
)

# 9. Link Booked Seats (Assign Row A Seat 1 and Row A Seat 2 to the booking)
seat_a1 = screen_one.seats.find_by(row_name: 'A', seat_number: 1)
seat_a2 = screen_one.seats.find_by(row_name: 'A', seat_number: 2)

BookingSeat.create!(booking: booking, seat: seat_a1)
BookingSeat.create!(booking: booking, seat: seat_a2)

# 10. Payments
Payment.create!(
  booking: booking,
  amount: 31.00,
  gateway_name: "Stripe",
  paid_at: Time.current - 1.hour,
  payment_status: :successfull, # matching your spelling from model enum "successfull"
  transaction_id: "TXN_998234123"
)

puts "Creating Temporary Seat Locks..."

# 11. Seat Locks (Mocking another user currently holding Row B Seat 5)
seat_b5 = screen_one.seats.find_by(row_name: 'B', seat_number: 5)
SeatLock.create!(
  user: customer,
  show: show_im_1,
  seat: seat_b5,
  expires_at: 10.minutes.from_now,
  status: 1
)
