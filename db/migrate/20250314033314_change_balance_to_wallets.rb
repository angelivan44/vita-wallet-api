class ChangeBalanceToWallets < ActiveRecord::Migration[8.0]
  def change
    change_column :wallets, :balance, :float
  end
end
