class AddPriceToGroup < ActiveRecord::Migration[5.0]
  def change
  	add_column :groups, :price, :float, :default => 0.0
  end
end
