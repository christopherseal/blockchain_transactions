# app/services/near_api_service.rb
require "httparty"

class NearApiService
  BASE_URL = "https://4816b0d3-d97d-47c4-a02c-298a5081c0f9.mock.pstmn.io/near/transactions"
  API_KEY = ENV.fetch("NEAR_API_KEY", "SECRET_API_KEY")

  def self.fetch_transactions
    response = HTTParty.get("#{BASE_URL}?api_key=#{API_KEY}")

    return [] unless response.success?

    transactions = response.parsed_response

    transactions.select { |tx| tx.dig("actions", 0, "type") == "Transfer" }.map do |tx|
      {
        transaction_hash: tx["hash"],
        block_height: tx["height"],
        block_hash: tx["block_hash"],
        sender: tx["sender"],
        receiver: tx.dig("actions", 0, "receiver_id"),
        deposit: tx.dig("actions", 0, "deposit").to_f,
        timestamp: Time.parse(tx["time"])
      }
    end
  rescue StandardError => e
    Rails.logger.error "NEAR API Error: #{e.message}"
    []
  end
end
