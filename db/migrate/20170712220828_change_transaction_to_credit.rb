class ChangeTransactionToCredit < ActiveRecord::Migration[5.0]
  def change
  	drop_table :transactions
  	create_table :credits do |t|
  		t.integer :transaction_id
  		t.float :value, :default => 0.0
  		t.integer :parent_id, foreign_key: true
  		t.integer :sign, :default => 1
  		t.boolean :available, :default => true

  		t.timestamps
  	end
  end
end
