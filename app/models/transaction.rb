class Transaction < ApplicationRecord
  validates :transaction_hash, uniqueness: true
end
