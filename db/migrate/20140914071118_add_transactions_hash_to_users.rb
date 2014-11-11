class AddTransactionsHashToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :users_transaction_hash, :text, default: ""
  end
end
