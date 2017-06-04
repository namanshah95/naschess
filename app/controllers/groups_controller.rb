class GroupsController < ApplicationController

	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
		@groupless = Child.where(group_id: nil)
	end

	def create
		@group = Group.new(group_params)

		child1 = group_params[:child1] == "" ? nil : Child.find(group_params[:child1])
		child2 = group_params[:child2] == "" ? nil : Child.find(group_params[:child2])
		child3 = group_params[:child3] == "" ? nil : Child.find(group_params[:child3])
		child4 = group_params[:child4] == "" ? nil : Child.find(group_params[:child4])
		
		if @group.save and (child1 == nil or child1.update_attribute(:group_id, @group.id)) and (child2 == nil or child2.update_attribute(:group_id, @group.id)) and (child3 == nil or child3.update_attribute(:group_id, @group.id)) and (child4 == nil or child4.update_attribute(:group_id, @group.id))
			flash[:notice] = "New group has been successfully created!"
			redirect_to groups_path
		else
			flash.now[:alert] = "Not able to create group!"
			render "new"
		end
	end

	def edit
		@group = Group.find(params[:id])
	end

	def update
		@group = Group.find(params[:id])

		if @group.update(group_params)
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
