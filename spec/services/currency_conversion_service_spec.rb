require 'rails_helper'

RSpec.describe CurrencyConversionService do
  describe ".get_conversion_rate" do
    context "when converting from USD to BTC" do
      before do
        # Mock the API response
        allow(RestClient).to receive(:get)
          .with("#{CurrencyConversionService::BASE_URL}/simple/price?ids=bitcoin&vs_currencies=usd")
          .and_return(double(body: '{"bitcoin":{"usd":24254.32}}'))
      end

      it "returns the correct conversion rate" do
        rate = CurrencyConversionService.get_conversion_rate("USD", "BTC")
        expected_rate = (1.0 / 24254.32).round(8)
        expect(rate).to eq(expected_rate)
      end
    end

    context "when converting from BTC to USD" do
      before do
        # Mock the API response
        allow(RestClient).to receive(:get)
          .with("#{CurrencyConversionService::BASE_URL}/simple/price?ids=bitcoin&vs_currencies=usd")
          .and_return(double(body: '{"bitcoin":{"usd":24254.32}}'))
      end

      it "returns the correct conversion rate" do
        rate = CurrencyConversionService.get_conversion_rate("BTC", "USD")
        expected_rate = 24254.32.round(8)
        expect(rate).to eq(expected_rate)
      end
    end

    context "when the API call fails" do
      before do
        allow(RestClient).to receive(:get)
          .and_raise(RestClient::ExceptionWithResponse.new(double(response: "API Error")))
      end

      it "raises an error" do
        expect {
          CurrencyConversionService.get_conversion_rate("USD", "BTC")
        }.to raise_error(/Error fetching price/)
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(RestClient).to receive(:get)
          .and_raise(StandardError.new("Unexpected error"))
      end

      it "raises an error" do
        expect {
          CurrencyConversionService.get_conversion_rate("USD", "BTC")
        }.to raise_error(/Failed to get conversion rate/)
      end
    end

    context "with unsupported currency pair" do
      it "returns nil" do
        rate = CurrencyConversionService.get_conversion_rate("EUR", "JPY")
        expect(rate).to be_nil
      end
    end
  end
end
