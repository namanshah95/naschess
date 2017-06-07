class GroupsController < ApplicationController

	def index
	end

	def new
		require_user!(admin_logged_in?)
		@group = Group.new
		@groupless = Child.where(group_id: nil)
		@tutors = Tutor.all
	end

	def create
		gp = group_params
		gp[:tutor] = Tutor.find(gp[:tutor])
		@group = Group.new(gp)

		child1 = gp[:child1] == "" ? nil : Child.find(gp[:child1])
		child2 = gp[:child2] == "" ? nil : Child.find(gp[:child2])
		child3 = gp[:child3] == "" ? nil : Child.find(gp[:child3])
		child4 = gp[:child4] == "" ? nil : Child.find(gp[:child4])
		
		if @group.save and (child1.nil? or child1.update_attribute(:group_id, @group.id)) and (child2.nil? or child2.update_attribute(:group_id, @group.id)) and (child3.nil? or child3.update_attribute(:group_id, @group.id)) and (child4.nil? or child4.update_attribute(:group_id, @group.id))
			flash[:notice] = "New group has been successfully created!"
			redirect_to groups_path
		else
			flash.now[:alert] = "Not able to create group!"
			render "new"
		end
	end

	def edit
		require_user!(admin_logged_in?)
		@group = Group.find(params[:id])
		@tutors = Tutor.all
	end

	def update
		@group = Group.find(params[:id])

		gp = group_params
		gp[:tutor] = Tutor.find(gp[:tutor])

		if @group.update(gp)
			flash[:notice] = "Group #" + @group.id.to_s + " has been successfully updated!"
			redirect_to groups_path
		else
			flash.now[:alert] = "Not able to update Group #" + @group.id.to_s + "!"
			render "edit"
		end
	end

	private

	def group_params
		params.require(:group).permit(:tutor, :schedule, :child1, :child2, :child3, :child4)
	end
end
