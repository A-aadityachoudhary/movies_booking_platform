class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :transaction_id
      t.string :gateway_name
      t.decimal :amount
      t.integer :payment_status
      t.datetime :paid_at

      t.timestamps
    end
  end
end
