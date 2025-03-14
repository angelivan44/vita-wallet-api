require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let!(:user) { User.create!(email: "test@example.com", username: "testuser") }

  # Make sure wallets are created for the user
  before do
    user.send(:create_wallets)
  end

  describe "GET /users/:user_id/transactions" do
    let!(:transaction) do
      Transaction.create!(
        user: user,
        currency_from: "USD",
        currency_to: "BTC",
        amount_from: 100.0,
        amount_to: 0.00412300,
        exchange_rate: 0.00004123
      )
    end

    it "returns all transactions for a user" do
      get "/users/#{user.id}/transactions"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]["id"]).to eq(transaction.id)
      expect(json_response[0]["currency_from"]).to eq("USD")
      expect(json_response[0]["currency_to"]).to eq("BTC")
    end
  end

  describe "GET /users/:user_id/transactions/:id" do
    let!(:transaction) do
      Transaction.create!(
        user: user,
        currency_from: "USD",
        currency_to: "BTC",
        amount_from: 100.0,
        amount_to: 0.00412300,
        exchange_rate: 0.00004123
      )
    end

    it "returns the transaction" do
      get "/users/#{user.id}/transactions/#{transaction.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(transaction.id)
      expect(json_response["currency_from"]).to eq("USD")
      expect(json_response["currency_to"]).to eq("BTC")
      expect(json_response["amount_from"].to_f).to eq(100.0)
      expect(json_response["amount_to"].to_f).to eq(0.00412300)
      expect(json_response["exchange_rate"].to_f).to eq(0.00004123)
    end

    context "when the transaction does not exist" do
      it "returns not found" do
        get "/users/#{user.id}/transactions/0"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /users/:user_id/transactions" do
    before do
      # Mock the CurrencyConversionService to avoid external API calls
      allow(CurrencyConversionService).to receive(:get_conversion_rate)
        .with("USD", "BTC")
        .and_return(0.00004123)
    end

    let(:valid_attributes) {
      {
        currency_from: "USD",
        currency_to: "BTC",
        amount_from: "100"
      }
    }

    context "with valid parameters" do
      it "creates a new Transaction" do
        expect {
          post "/users/#{user.id}/transactions", params: valid_attributes
        }.to change(Transaction, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["currency_from"]).to eq("USD")
        expect(json_response["currency_to"]).to eq("BTC")
        expect(json_response["amount_from"].to_f).to eq(100.0)
        expect(json_response["amount_to"].to_f).to be > 0
        expect(json_response["exchange_rate"].to_f).to eq(0.00004123)
      end
    end

    context "with invalid parameters" do
      it "does not create a transaction without currency_from" do
        expect {
          post "/users/#{user.id}/transactions", params: {
            transaction: { currency_to: "BTC", amount_from: 100.0 }
          }
        }.to change(Transaction, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a transaction with insufficient funds" do
        # Set initial balance
        usd_wallet = user.wallets.find_by(currency: "USD")
        usd_wallet.update(balance: 50.0)

        expect {
          post "/users/#{user.id}/transactions", params:  valid_attributes
        }.to change(Transaction, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to include("Insufficient funds")
      end
    end
  end
end
