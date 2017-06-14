class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.references :group, foreign_key: true
      t.string :notes
      t.datetime :datetime
      t.string :attendance

      t.timestamps
    end
  end
end
