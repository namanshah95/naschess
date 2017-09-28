class LessonsController < ApplicationController
	def new
		require_user!(tutor_logged_in?)
		@lesson = Lesson.new
		@groups = Group.where(tutor: current_tutor)
		@children = Array.new
	end

	def create
		lp = lesson_params

		lp[:group] = Group.find(lp[:group])
		dt = lp["datetime(1i)"] + lp["datetime(2i)"].rjust(2, "0") + lp["datetime(3i)"].rjust(2, "0") + lp["datetime(4i)"] + lp["datetime(5i)"]
		lp[:datetime] = DateTime.strptime(dt, "%Y%m%d%H%M")
		lp[:attendance].delete_if do |c_id|
			c_id.blank?
		end
		
		@lesson = Lesson.new(lp)

		if @lesson.save
			children = Child.where(group: @lesson.group)
			children.each do |child|
				# Create attendance record for each child
				ap = Hash.new
				ap[:lesson_id] = @lesson.id
				ap[:child_id] = child.id
				ap[:present] = lp[:attendance].include?(child.id.to_s)
				Attendance.create!(ap)
				# Create Stripe charge for parent of child
				if not child.parent.customer_id.nil?
					Stripe::Charge.create(
						amount: (@lesson.group.price * 100).to_i,
						currency: "usd",
						customer: child.parent.customer_id,
						description: child.name + "'s class on " + @lesson.datetime.to_s
					)
				end
			end

			flash[:notice] = "New lesson has been added successfully!"
			redirect_to tutor_lessons_path(@lesson.group.tutor)
		else
			flash.now[:alert] = "Not able to add lesson!"
			render "new"
		end
	end

	def update_attendance
		@children = Array.new
		if params[:group].present?
			@children = Child.where(group: params[:group])
		end
		respond_to do |format|
			format.js
		end
	end

	private

	def lesson_params
		params.require(:lesson).permit(:group, :datetime, :notes, :attendance => [])
	end
end
