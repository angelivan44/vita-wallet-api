class ExchangesController < ApplicationController
  def btc_to_usd_price
    from_currency_code = "USD"
    to_currency_code = "BTC"

    exchange_rate = CurrencyConversionService.get_conversion_rate(from_currency_code, to_currency_code)


    if exchange_rate.nil?
      render json: { error: "Failed to fetch BTC price" }, status: :internal_server_error
    else
      render json: { currency: "BTC", price: exchange_rate }, status: :ok
    end
  end
end
