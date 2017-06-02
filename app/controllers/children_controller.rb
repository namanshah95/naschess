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
			flash[:notice] = "New child has been created successfully!"
			redirect_to child_path(@child)
		else
			flash.now[:alert] = "Not able to add child!"
			render "new"
		end
	end

	def edit
		redirect_to child_path(params[:id])
	end

	def update
	end

	private

	def child_params
		params.require(:child).permit(:name, :age, :grade, :skill)
	end
end
