class ChildrenController < ApplicationController

	def index
		@children = Child.all
	end

	def show
		@child = Child.find(params[:id])
	end

	def new
		@child = Child.new
	end

	def create
		@child = Child.new(child_params)

		if @child.save
			flash[:notice] = "New child has been added successfully!"
			redirect_to child_path(@child)
		else
			flash.now[:alert] = "Not able to add child!"
			render "new"
		end
	end

	def edit
		@child = Child.find(params[:id])
	end

	def update
		@child = Child.find(params[:id])

		if @child.update(child_params)
			flash[:notice] = @child.name + "'s profile has been successfully updated!"
			redirect_to child_path(@child)
		else
			flash.now[:alert] = "Not able to update " + @child.name + "'s profile!"
			render "edit"
		end
	end

	def drop
		@child = Child.find(params[:id])

		if @child.update_attribute(:group_id, nil)
			flash[:notice] = @child.name + " has successfully dropped his/her group!"
		else
			flash.now[:alert] = "Unable to drop out of " + @child.name + "'s group!"
		end
		redirect_to child_path(@child)
	end

	private

	def child_params
		params.require(:child).permit(:name, :age, :grade, :skill)
	end
end
