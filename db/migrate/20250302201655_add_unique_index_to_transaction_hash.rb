class AddUniqueIndexToTransactionHash < ActiveRecord::Migration[8.0]
  def change
    add_index :transactions, :transaction_hash, unique: true
  end
end
