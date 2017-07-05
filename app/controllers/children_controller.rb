class ChildrenController < ApplicationController

	def index
		require_user!(admin_logged_in?)
		@children = Child.all
	end

	def show
		@child = Child.find(params[:id])
		require_user!(admin_logged_in? || current_parent == @child.parent)
		@attendance = Attendance.where(child: @child).sort do |a, b|
			b.lesson.datetime <=> a.lesson.datetime
		end
	end

	def new
		require_user!(parent_logged_in?)
		@child = Child.new
	end

	def create
		@child = Child.new(child_params)
		@child.parent = current_parent

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
		require_user!(admin_logged_in? || current_user == @child.parent)
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
		require_user!(admin_logged_in? || current_parent == @child.parent)

		if @child.update_attribute(:group_id, nil)
			flash[:notice] = @child.name + " has successfully dropped his/her group!"
		else
			flash.now[:alert] = "Unable to drop out of " + @child.name + "'s group!"
		end
		redirect_to child_path(@child)
	end

	private

	def child_params
		params.require(:child).permit(:name, :age, :grade, :skill, :parent)
	end
end
