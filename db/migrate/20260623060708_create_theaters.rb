class CreateTheaters < ActiveRecord::Migration[8.1]
  def change
    create_table :theaters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :contact_number
      t.string :email
      t.integer :status

      t.timestamps
    end
  end
end
