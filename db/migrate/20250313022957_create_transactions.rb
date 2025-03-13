class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency_from, null: false
      t.string :currency_to, null: false
      t.decimal :amount_from, precision: 10, scale: 2, null: false
      t.decimal :amount_to, precision: 10, scale: 2, null: false
      t.decimal :exchange_rate, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
