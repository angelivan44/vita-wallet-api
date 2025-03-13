# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  balance    :decimal(10, 2)   not null
#  currency   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_wallets_on_user_id  (user_id)
#
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, presence: true
  validates :currency, presence: true


  after_create :set_balance

  private

  def set_balance
    self.balance = 0
  end
end
