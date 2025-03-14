class TransactionsController < ApplicationController
  before_action :set_user, only: [ :create ]
  before_action :set_wallets, only: [ :create ]

  def create
    # Validate required parameters
    amount_from = transaction_params[:amount_from].to_f
    currency_from = transaction_params[:currency_from].upcase
    currency_to = transaction_params[:currency_to].upcase

    if currency_from.nil? || currency_to.nil? || amount_from <= 0
      render json: { error: "currency_from, currency_to, and amount_from are required and must be valid" }, status: :unprocessable_entity and return
    end

    # Check if the user has sufficient balance
    if @source_wallet.balance < amount_from
      render json: { error: "Insufficient funds in #{currency_from} wallet" }, status: :unprocessable_entity and return
    end

    exchange_rate = CurrencyConversionService.get_conversion_rate(currency_from, currency_to)

    # Ensure exchange_rate is valid before calculating amount_to
    if exchange_rate.nil? || exchange_rate.zero?
      render json: { error: "Invalid exchange rate" }, status: :unprocessable_entity
      return
    end

    amount_to = amount_from * exchange_rate.to_f

    # Use a transaction to ensure data consistency
    ActiveRecord::Base.transaction do
      # Create the transaction record
      transaction = Transaction.new(
        user: @user,
        amount_from: amount_from,
        amount_to: amount_to,
        currency_from: currency_from,
        currency_to: currency_to,
        exchange_rate: exchange_rate
      )

      if transaction.save
        # Update wallet balances
        @source_wallet.update!(balance: @source_wallet.balance - amount_from)
        @destination_wallet.update!(balance: @destination_wallet.balance + amount_to)

        render json: transaction, status: :created
      else
        # If transaction save fails, the ActiveRecord::Base.transaction will rollback
        render json: transaction.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    transactions = Transaction.all
    render json: transactions, status: :ok
  end

  def show
    transaction = Transaction.find_by(id: params[:id])
    if transaction
      render json: transaction, status: :ok
    else
      render json: { error: "Transaction not found" }, status: :not_found
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_wallets
    currency_from = transaction_params[:currency_from].upcase if transaction_params[:currency_from].present?
    currency_to = transaction_params[:currency_to].upcase if transaction_params[:currency_to].present?
    @source_wallet = @user.wallets.find_by(currency: currency_from)
    @destination_wallet = @user.wallets.find_by(currency: currency_to)

    if @source_wallet.nil? || @destination_wallet.nil?
      render json: { error: "User does not have the required wallets" }, status: :unprocessable_entity and return
    end
  end

  def transaction_params
    params.permit(:amount_from, :currency_from, :currency_to)
  end
end
