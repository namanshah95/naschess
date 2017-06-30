class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.references :lesson, foreign_key: true
      t.references :child, foreign_key: true
      t.boolean :present

      t.timestamps
    end
  end
end
