class ChangeTutorToReference < ActiveRecord::Migration[5.0]
  def change
  	remove_column :groups, :tutor
  	add_reference :groups, :tutor, index: true, foreign_key: true
  end
end
