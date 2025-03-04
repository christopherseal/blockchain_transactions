class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.order(created_at: :desc).limit(50)
  end
end
