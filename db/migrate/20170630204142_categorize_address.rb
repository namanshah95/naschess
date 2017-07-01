class CategorizeAddress < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :address
  	add_column :users, :street_address, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :zip, :string
  end
end
