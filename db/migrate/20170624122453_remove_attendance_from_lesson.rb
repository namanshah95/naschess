class RemoveAttendanceFromLesson < ActiveRecord::Migration[5.0]
  def change
  	remove_column :lessons, :attendance
  end
end
