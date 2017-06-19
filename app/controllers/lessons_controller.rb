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

		children = Child.where(group: @lesson.group)
		children.each do |child|
			tp = Hash.new
			tp[:parent_id] = child.parent.id
			if children.count == 3
				tp[:balance_delta] = -20.0
				tp[:c20_delta] = -1
			end
			if children.count == 4
				tp[:balance_delta] = -15.0
				tp[:c15_delta] = -1
			end
			tp[:description] = child.name + "'s class with Group #" + @lesson.group.id.to_s + " on " + @lesson.datetime.strftime("%m/%d/%Y")
			Transaction.new(tp).save
		end

		if @lesson.save
			flash[:notice] = "New lesson has been added successfully!"
			redirect_to tutor_lessons_path(@lesson.group.tutor)
		else
			flash.now[:alert] = "Not able to add lesson!"
			render "new"
		end
	end

	private

	def lesson_params
		params.require(:lesson).permit(:group, :datetime, :notes, :attendance)
	end
end
