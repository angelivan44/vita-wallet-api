require "rest-client"
require "json"
require "bigdecimal"

module CurrencyConversionService
  BASE_URL = "https://api.coingecko.com/api/v3"

  def self.get_conversion_rate(from_currency, to_currency)
    return convert_from_usd if from_currency == "USD" && to_currency == "BTC"
    return convert_to_usd if from_currency == "BTC" && to_currency == "USD"

    nil
  end

  class << self
    private

    def convert_from_usd
      price =  get_price("bitcoin", "usd")
      (BigDecimal("1.0") / BigDecimal(price.to_s)).round(8) if price.positive?
    end

    def convert_to_usd
      BigDecimal(get_price("bitcoin", "usd").to_s).round(8)
    end

    def get_price(coin_id, vs_currency)
      response = RestClient.get("#{BASE_URL}/simple/price?ids=#{coin_id}&vs_currencies=#{vs_currency}")
      data = JSON.parse(response.body)
      data[coin_id][vs_currency]
    rescue RestClient::ExceptionWithResponse => e
      raise "Error fetching price: #{e.response}"
    rescue StandardError => e
      raise "Failed to get conversion rate: #{e.message}"
    end
  end
end
