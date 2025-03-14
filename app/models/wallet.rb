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
class Wallet < ApplicationRecord
  belongs_to :user

  validates :currency, presence: true

  attribute :balance, default: 0.0

  # No need for before_create callback to set balance
end
