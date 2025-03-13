# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  amount_from   :decimal(10, 2)   not null
#  amount_to     :decimal(10, 2)   not null
#  currency_from :string           not null
#  currency_to   :string           not null
#  exchange_rate :decimal(10, 2)   not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_transactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :user

  validates :amount_from, presence: true
  validates :amount_to, presence: true
  validates :currency_from, presence: true
  validates :currency_to, presence: true
  validates :exchange_rate, presence: true

  enum currency_from: {
    usd: "USD",
    btc: "BTC"
  }

  enum currency_to: {
    usd: "USD",
    btc: "BTC"
  }
end
