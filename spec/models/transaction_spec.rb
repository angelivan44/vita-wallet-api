# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  amount_from   :float            not null
#  amount_to     :float            not null
#  currency_from :string           not null
#  currency_to   :string           not null
#  exchange_rate :float            not null
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
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create!(email: "test@example.com", username: "testuser") }

  it "is valid with valid attributes" do
    transaction = Transaction.new(
      user: user,
      currency_from: "USD",
      currency_to: "BTC",
      amount_from: 100.0,
      amount_to: 0.00412300,
      exchange_rate: 0.00004123
    )
    expect(transaction).to be_valid
  end

  it "is not valid without a user" do
    transaction = Transaction.new(
      currency_from: "USD",
      currency_to: "BTC",
      amount_from: 100.0,
      amount_to: 0.00412300,
      exchange_rate: 0.00004123
    )
    expect(transaction).not_to be_valid
  end

  it "is not valid without currency_from" do
    transaction = Transaction.new(
      user: user,
      currency_to: "BTC",
      amount_from: 100.0,
      amount_to: 0.00412300,
      exchange_rate: 0.00004123
    )
    expect(transaction).not_to be_valid
  end

  it "is not valid without currency_to" do
    transaction = Transaction.new(
      user: user,
      currency_from: "USD",
      amount_from: 100.0,
      amount_to: 0.00412300,
      exchange_rate: 0.00004123
    )
    expect(transaction).not_to be_valid
  end

  it "is not valid without amount_from" do
    transaction = Transaction.new(
      user: user,
      currency_from: "USD",
      currency_to: "BTC",
      amount_to: 0.00412300,
      exchange_rate: 0.00004123
    )
    expect(transaction).not_to be_valid
  end

  it "is not valid without amount_to" do
    transaction = Transaction.new(
      user: user,
      currency_from: "USD",
      currency_to: "BTC",
      amount_from: 100.0,
      exchange_rate: 0.00004123
    )
    expect(transaction).not_to be_valid
  end

  it "is not valid without exchange_rate" do
    transaction = Transaction.new(
      user: user,
      currency_from: "USD",
      currency_to: "BTC",
      amount_from: 100.0,
      amount_to: 0.00412300
    )
    expect(transaction).not_to be_valid
  end
end
