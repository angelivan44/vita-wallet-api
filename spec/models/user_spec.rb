# == Schema Information
#
# Table name: users
#
#  id       :bigint           not null, primary key
#  email    :string           not null
#  username :string           not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email: "test@example.com", username: "testuser")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(username: "testuser")
    expect(user).not_to be_valid
  end

  it "is not valid without a username" do
    user = User.new(email: "test@example.com")
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    User.create!(email: "test@example.com", username: "testuser1")
    user = User.new(email: "test@example.com", username: "testuser2")
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate username" do
    User.create!(email: "test1@example.com", username: "testuser")
    user = User.new(email: "test2@example.com", username: "testuser")
    expect(user).not_to be_valid
  end

  it "creates USD and BTC wallets after creation" do
    user = User.create!(email: "test@example.com", username: "testuser")
    expect(user.wallets.count).to eq(2)
    expect(user.wallets.pluck(:currency)).to contain_exactly("USD", "BTC")
  end
end
