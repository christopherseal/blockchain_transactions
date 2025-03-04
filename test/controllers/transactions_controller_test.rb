require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @transaction1 = Transaction.create!(
      transaction_hash: "hash_1",
      block_height: 1001,
      block_hash: "block_1",
      sender: "sender_1",
      receiver: "receiver_1",
      deposit: BigDecimal("10.5"),
      timestamp: Time.now
    )

    @transaction2 = Transaction.create!(
      transaction_hash: "hash_2",
      block_height: 1002,
      block_hash: "block_2",
      sender: "sender_2",
      receiver: "receiver_2",
      deposit: BigDecimal("20.0"),
      timestamp: Time.now - 5.minutes
    )
  end
  test "should get index" do
    get transactions_url
    assert_response :success
  end
  test "should assign transactions ordered by created_at desc" do
    get transactions_url
    assert_response :success
    assert_includes response.body, @transaction1.transaction_hash
    assert_includes response.body, @transaction2.transaction_hash
  end
  test "should render index template" do
    get transactions_url
    assert_response :success

    assert_select "h1", "NEAR Blockchain Transactions"
    assert_select "table.transactions-table"
  end
end
