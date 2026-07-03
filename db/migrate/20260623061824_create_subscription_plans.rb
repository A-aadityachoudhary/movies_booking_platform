class CreateSubscriptionPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.decimal :price
      t.integer :theater_limit
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
