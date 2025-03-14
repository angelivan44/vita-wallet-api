require 'rails_helper'

RSpec.describe "Exchanges", type: :request do
  describe "GET /exchanges/btc_to_usd_price" do
    before do
      # Mock the CurrencyConversionService to avoid external API calls
      allow(CurrencyConversionService).to receive(:get_conversion_rate)
        .with("USD", "BTC")
        .and_return(0.00004123)
    end

    it "returns the BTC price" do
      get "/exchanges/btc_to_usd_price"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["currency"]).to eq("BTC")
      expect(json_response["price"]).to eq(0.00004123)
    end

    context "when the service fails" do
      before do
        allow(CurrencyConversionService).to receive(:get_conversion_rate)
          .with("USD", "BTC")
          .and_return(nil)
      end

      it "returns an error" do
        get "/exchanges/btc_to_usd_price"

        expect(response).to have_http_status(:internal_server_error)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Failed to fetch BTC price")
      end
    end
  end
end
