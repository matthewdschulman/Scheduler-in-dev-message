class AddUserAttributesForPlaidSync < ActiveRecord::Migration
  def change
  	add_column :users, :phone_number, :string, default: ""
  	add_column :users, :most_recent_plaid_sync, :text, default: ""
  end
end
