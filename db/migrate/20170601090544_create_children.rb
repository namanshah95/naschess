class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :name
      t.integer :age
      t.integer :grade
      t.integer :skill
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
