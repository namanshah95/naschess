class AddBalanceToParents < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :balance, :float, :default => 0.0
  	add_column :users, :C20, :integer, :default => 0
  	add_column :users, :C15, :integer, :default => 0
  end
end
