class TransactionsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    amount_from = params[:amount_from].to_f
    currency_from = params[:currency_from].upcase
    currency_to = params[:currency_to].upcase

    exchange_rate = CurrencyConversionService.get_conversion_rate(currency_from, currency_to)

    # Ensure exchange_rate is valid before calculating amount_to
    if exchange_rate.nil? || exchange_rate.zero?
      render json: { error: "Invalid exchange rate" }, status: :unprocessable_entity
      return
    end

    amount_to = amount_from * exchange_rate.to_f

    transaction = Transaction.new(
      user: user,
      amount_from: amount_from,
      amount_to: amount_to,
      currency_from: currency_from,
      currency_to: currency_to,
      exchange_rate: exchange_rate
    )

    if transaction.save
      render json: transaction, status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  def index
    transactions = Transaction.all
    render json: transactions, status: :ok
  end

  def show
    transaction = Transaction.find(params[:id])
    if transaction.present?
      render json: transaction, status: :ok
    else
      render json: { error: "Transaction not found" }, status: :not_found
    end
  end
end
