class ChangeChildrenQualities < ActiveRecord::Migration[5.0]
  def change
  	remove_column :children, :age
  	remove_column :children, :grade
  	add_column :children, :grade, :string
  	remove_column :children, :skill
  	add_column :children, :skill, :string
  end
end
