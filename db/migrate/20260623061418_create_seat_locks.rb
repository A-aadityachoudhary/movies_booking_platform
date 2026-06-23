class CreateSeatLocks < ActiveRecord::Migration[8.1]
  def change
    create_table :seat_locks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.datetime :expires_at
      t.integer :status

      t.timestamps
    end
  end
end
