class GroupsController < ApplicationController

	def new
		require_user!(admin_logged_in?)
		@group = Group.new
		@tutors = Tutor.all
		@slot = 1
		@choices = Child.where(group: nil).sort_by do |c|
			c.parent
		end
		@hosts = Array.new
	end

	def create
		gp = group_params

		gp[:children].delete_if do |c_id|
			c_id.blank?
		end
		gp[:tutor] = Tutor.find(gp[:tutor])
		gp[:host] = Parent.find(gp[:host])
		# gp[:dow].delete_if do |d|
		# 	d.blank?
		# end
		# gp[:time].delete_if do |t|
		# 	t.blank?
		# end
		
		@group = Group.new(gp)

		# datetime_arr = (0...gp[:dow].count).map do |i|
		# 	DateTime.strptime(gp[:dow].at(i) + gp[:time].at(i), "%A%H:%M")
		# end

		# @group.schedule = encode_sched(datetime_arr.sort!)

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
			flash[:notice] = display_name(@group) + " has been successfully updated!"
			redirect_to admin_path(current_admin)
		else
			flash.now[:alert] = "Not able to update " + display_name(@group) + "!"
			render "edit"
		end
	end

	def add_slot
		respond_to do |format|
			format.js
		end
	end

	def remove_slot
		@slot = params[:slot]
		respond_to do |format|
			format.js
		end
	end

	def update_host
		@hosts = Set.new
		if params[:children].present?
			params[:children].each do |c_id|
				@hosts.add(Child.find(c_id).parent)
			end
		end
		respond_to do |format|
			format.js
		end
	end

	private

	def group_params
		params.require(:group).permit(:price, :tutor, :host, :children => [])
	end
end
