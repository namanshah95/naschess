class ChangeTutorToReference < ActiveRecord::Migration[5.0]
  def change
  	remove_column :groups, :tutor
  	add_column :groups, :tutor_id, :integer, index: true, foreign_key: true
  end
end
