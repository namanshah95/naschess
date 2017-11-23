class AddPriceToLesson < ActiveRecord::Migration[5.0]
  def change
  	add_column :lessons, :price, :float, :default => 0.0
  end
end
