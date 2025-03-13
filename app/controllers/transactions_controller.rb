class TransactionsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    amount_from = params[:amount_from].to_f
    currency_from = params[:currency_from]
    currency_to = params[:currency_to]

    exchange_rate = nil
    if currency_from == "BTC" && currency_to == "USD"
      exchange_rate = BitcoinPriceService.fetch_btc_price
    elsif currency_from == "USD" && currency_to == "BTC"
      exchange_rate = 1 / BitcoinPriceService.fetch_btc_price
    end

    transaction = Transaction.new(
      user: user,
      amount_from: amount_from,
      amount_to: amount_from * exchange_rate,
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
