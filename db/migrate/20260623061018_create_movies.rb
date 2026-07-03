class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.string :language
      t.string :genre
      t.date :release_date
      t.integer :status

      t.timestamps
    end
  end
end
