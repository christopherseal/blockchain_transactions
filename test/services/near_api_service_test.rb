require "test_helper"
require "minitest/mock"

class NearApiServiceTest < ActiveSupport::TestCase
  def setup
    @transaction_hash = "unique_hash_#{SecureRandom.hex(5)}"

    @valid_response = [
      {
        "hash" => @transaction_hash,
        "height" => 27326763,
        "block_hash" => "FrWmh1BtBc8yvAZPJrJ97nVth6eryukbLANyFQ3TuQai",
        "sender" => "86e6ebcc723106eee951c344825b91a80b46f42ff8b1f4bd366f2ac72fab99d1",
        "receiver" => "d73888a2619c7761735f23c798536145dfa87f9306b5f21275eb4b1a7ba971b9",
        "time" => "2021-01-11T10:20:04.132926-06:00",
        "actions" => [
          {
            "data" => { "deposit" => "716669915088987500000000000" },
            "type" => "Transfer"
          }
        ]
      }
    ]
  end

  test "fetch_transactions returns an array" do
    HTTParty.stub :get, OpenStruct.new(success?: true, parsed_response: @valid_response) do
      result = NearApiService.fetch_transactions
      assert_kind_of Array, result
    end
  end

  test "fetch_transactions parses transaction data correctly" do
    HTTParty.stub :get, OpenStruct.new(success?: true, parsed_response: @valid_response) do
      result = NearApiService.fetch_transactions
      transaction = result.first

      assert_equal @transaction_hash, transaction[:transaction_hash]
      assert_equal 27326763, transaction[:block_height]
      assert_equal "FrWmh1BtBc8yvAZPJrJ97nVth6eryukbLANyFQ3TuQai", transaction[:block_hash]
      assert_equal "86e6ebcc723106eee951c344825b91a80b46f42ff8b1f4bd366f2ac72fab99d1", transaction[:sender]
      assert_equal "d73888a2619c7761735f23c798536145dfa87f9306b5f21275eb4b1a7ba971b9", transaction[:receiver]
      assert_equal BigDecimal("716669915088987500000000000") / 10**24, transaction[:deposit]
      assert_kind_of Time, transaction[:timestamp]
    end
  end

  test "fetch_transactions handles empty response" do
    HTTParty.stub :get, OpenStruct.new(success?: true, parsed_response: []) do
      result = NearApiService.fetch_transactions
      assert_empty result
    end
  end

  test "fetch_transactions filters out non-transfer transactions" do
    invalid_response = [
      {
        "hash" => "non_transfer_tx",
        "actions" => [ { "type" => "FunctionCall" } ]
      }
    ]
    HTTParty.stub :get, OpenStruct.new(success?: true, parsed_response: invalid_response) do
      result = NearApiService.fetch_transactions
      assert_empty result
    end
  end

  test "fetch_transactions returns empty array when API call fails" do
    HTTParty.stub :get, OpenStruct.new(success?: false) do
      result = NearApiService.fetch_transactions
      assert_empty result
    end
  end

  test "fetch_transactions returns empty array when an exception occurs" do
    HTTParty.stub :get, ->(_) { raise StandardError.new("API is down") } do
      result = NearApiService.fetch_transactions
      assert_empty result
    end
  end
end
