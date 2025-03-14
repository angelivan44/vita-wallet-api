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
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
