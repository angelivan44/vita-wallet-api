class ChangeDecimalToFloatTransaction < ActiveRecord::Migration[8.0]
  def change
    change_column :transactions, :amount_from, :float
    change_column :transactions, :amount_to, :float
    change_column :transactions, :exchange_rate, :float
  end
end
