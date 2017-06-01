class GroupsController < ApplicationController

	def index
		@groups = Group.all
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(group_params)

		if @group.save
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
		params.require(:group).permit(:tutor, :schedule)
	end
end
