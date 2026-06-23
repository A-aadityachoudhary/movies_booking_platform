class CreateScreens < ActiveRecord::Migration[8.1]
  def change
    create_table :screens do |t|
      t.references :theater, null: false, foreign_key: true
      t.string :name
      t.integer :total_seats
      t.integer :screen_type
      t.integer :status

      t.timestamps
    end
  end
end
