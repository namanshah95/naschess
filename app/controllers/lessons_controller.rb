class LessonsController < ApplicationController
	def new
		require_user!(tutor_logged_in?)
		@lesson = Lesson.new
		@groups = Group.where(tutor: current_tutor)
	end

	def create
		lp = lesson_params

		lp[:group] = Group.find(lp[:group])
		dt = lp["datetime(1i)"] + lp["datetime(2i)"].rjust(2, "0") + lp["datetime(3i)"] + lp["datetime(4i)"] + lp["datetime(5i)"]
		lp[:datetime] = DateTime.strptime(dt, "%Y%m%d%H%M")
		
		@lesson = Lesson.new(lp)

		if @lesson.save
			flash[:notice] = "New lesson has been added successfully!"
			redirect_to tutor_lessons_path(@lesson.group.tutor)
		else
			flash.now[:alert] = "Not able to add lesson!"
			render "new"
		end
	end

	def update_attendance
		@children = Child.where(group_id: params[:group_id])
		respond_to do |format|
			format.js
		end
	end

	private

	def lesson_params
		params.require(:lesson).permit(:group, :datetime, :notes, :attendance)
	end
end
