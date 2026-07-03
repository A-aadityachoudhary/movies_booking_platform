class CreateSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :seats do |t|
      t.references :screen, null: false, foreign_key: true
      t.integer :seat_number
      t.string :row_name
      t.integer :category

      t.timestamps
    end
  end
end
