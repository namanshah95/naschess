class ChangeParentToReference < ActiveRecord::Migration[5.0]
  def change
  	remove_column :children, :parent
  	add_column :children, :parent_id, :integer, index: true, foreign_key: true
  end
end
