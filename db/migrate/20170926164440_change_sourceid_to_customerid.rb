class ChangeSourceidToCustomerid < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :source_id
  	add_column :users, :customer_id, :string
  end
end
