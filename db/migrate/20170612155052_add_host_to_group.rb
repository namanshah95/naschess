class AddHostToGroup < ActiveRecord::Migration[5.0]
  def change
  	add_reference :groups, :host, index: true
  	add_foreign_key :groups, :users, column: :host_id
  end
end
