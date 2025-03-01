class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_hash
      t.integer :block_height
      t.string :block_hash
      t.string :sender
      t.string :receiver
      t.decimal :deposit
      t.datetime :timestamp

      t.timestamps
    end
  end
end
