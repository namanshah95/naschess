class ParentsController < ApplicationController
	
	def index
		@parents = Parent.all
	end

	def show
		@parent = Parent.find(params[:id])
		@children = Child.where(parent: @parent)
	end
end
