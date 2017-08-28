class RemoveColumnsFromUser < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :C20
  	remove_column :users, :C15
  	remove_column :users, :balance
  end
end
