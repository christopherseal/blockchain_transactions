class FetchTransactionsJob < ApplicationJob
  queue_as :default

  def perform
    transactions = NearApiService.fetch_transactions

    transactions.each do |tx|
      Transaction.find_or_create_by(transaction_hash: tx[:transaction_hash]) do |transaction|
        transaction.assign_attributes(tx)
        transaction.save
      end
    end
  end
end
