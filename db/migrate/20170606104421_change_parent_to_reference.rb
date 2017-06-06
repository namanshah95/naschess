class ChangeParentToReference < ActiveRecord::Migration[5.0]
  def change
  	remove_column :children, :parent
  	add_reference :children, :parent, index: true, foreign_key: true
  end
end
