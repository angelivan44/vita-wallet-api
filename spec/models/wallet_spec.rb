# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  balance    :float            not null
#  currency   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_wallets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:user) { User.create!(email: "test@example.com", username: "testuser") }

  it "is valid with valid attributes" do
    wallet = Wallet.new(user: user, currency: "USD", balance: 0)
    expect(wallet).to be_valid
  end

  it "is not valid without a user" do
    wallet = Wallet.new(currency: "USD", balance: 0)
    expect(wallet).not_to be_valid
  end

  it "is not valid without a currency" do
    wallet = Wallet.new(user: user, balance: 0)
    expect(wallet).not_to be_valid
  end

  it "is valid without a balance" do
    wallet = Wallet.new(user: user, currency: "USD")
    expect(wallet).to be_valid
  end

  it "sets balance to 0 after creation" do
    wallet = Wallet.create!(user: user, currency: "USD")
    expect(wallet.balance).to eq(0)
  end
end
