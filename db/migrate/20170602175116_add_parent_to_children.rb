class AddParentToChildren < ActiveRecord::Migration[5.0]
  def change
    add_column :children, :parent, :string
  end
end
