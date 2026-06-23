class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.string :booking_reference
      t.integer :total_tickets
      t.decimal :total_amount
      t.integer :booking_status
      t.integer :payment_status
      t.datetime :booked_at

      t.timestamps
    end
  end
end
