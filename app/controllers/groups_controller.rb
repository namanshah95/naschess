class GroupsController < ApplicationController

	def index
	end

	def new
		require_user!(admin_logged_in?)
		@group = Group.new
		@choices = Child.where(group: nil)
		@tutors = Tutor.all
	end

	def create
		gp = group_params

		gp[:children].delete_if do |c_id|
			c_id.nil? || c_id.empty?
		end
		gp[:tutor] = Tutor.find(gp[:tutor])
		@group = Group.new(gp)

		datetime_arr = (0...gp[:dow].count).map do |i|
			DateTime.strptime(gp[:dow].at(i) + gp[:time].at(i), "%A%H:%M")
		end

		@group.schedule = encode_sched(datetime_arr.sort!)

		succ = true
		gp[:children].each do |c_id|
			child = Child.find(c_id)
			child.group = @group
			if !child.save
				succ = false
			end
		end
		
		if succ and @group.save
			flash[:notice] = "New group has been successfully created!"
			redirect_to admin_path(current_admin)
		else
			flash.now[:alert] = "Not able to create group!"
			render "new"
		end
	end

	def edit
		require_user!(admin_logged_in?)
		@group = Group.find(params[:id])
		existing = Child.where(group: @group)
		@existing_id = existing.pluck(:id)
		unassigned = Child.where(group: nil)
		@choices = existing + unassigned
		@tutors = Tutor.all
	end

	def update
		@group = Group.find(params[:id])
		@choices = Child.where(group: [nil, @group])

		gp = group_params
		gp[:tutor] = Tutor.find(gp[:tutor])

		succ = true
		@choices.each do |child|
			if gp[:children].include?(child.id.to_s)
				child.group = @group
			else
				child.group = nil
			end

			if !child.save
				succ = false
			end
		end

		if succ and @group.update(gp)
			flash[:notice] = "Group #" + @group.id.to_s + " has been successfully updated!"
			redirect_to admin_path(current_admin)
		else
			flash.now[:alert] = "Not able to update Group #" + @group.id.to_s + "!"
			render "edit"
		end
	end

	private

	def group_params
		params.require(:group).permit(:tutor, :schedule, :children => [], :dow => [], :time => [])
	end
end
