# == Schema Information
#
# Table name: users
#
#  id       :bigint           not null, primary key
#  email    :string           not null
#  username :string           not null
#
class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :wallets, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  after_create :create_wallets

  private

  def create_wallets
    Wallet.create(user: self, currency: "USD", balance: 1000)
    Wallet.create(user: self, currency: "BTC", balance: 0)
  end
end
