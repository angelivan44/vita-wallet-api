class ExchangesController < ApplicationController
  def btc_to_usd_price
    exchange_rate = BitcoinPriceService.fetch_btc_price

    if exchange_rate.nil?
      render json: { error: "Failed to fetch BTC price" }, status: :internal_server_error
    else
      render json: { currency: "BTC", price: exchange_rate }, status: :ok
    end
  end
end
