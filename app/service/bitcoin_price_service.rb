require "rest-client"

class BitcoinPriceService
  COINDESK_URL = "https://api.coindesk.com/v1/bpi/currentprice/USD.json"

  def self.fetch_btc_price
    response = RestClient.get(COINDESK_URL)
    json = JSON.parse(response.body)
    json["bpi"]["USD"]["rate_float"]
  rescue StandardError => e
    Rails.logger.error "Error fetching BTC price: #{e.message}"
    nil
  end
end
