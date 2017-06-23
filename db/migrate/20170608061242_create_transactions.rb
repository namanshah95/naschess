class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.float :balance_delta
      t.integer :c20_delta
      t.integer :c15_delta
      t.integer :parent_id, foreign_key: true

      t.timestamps
    end
  end
end
