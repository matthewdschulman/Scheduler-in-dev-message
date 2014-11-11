class AddAllTimeCountToEachUser < ActiveRecord::Migration
  def change
  	add_column :users, :all_time_cents_count, :integer, default: 0
  end
end
