class ParentsController < ApplicationController
	def show
		@parent = Parent.find(params[:id])
		@children = Child.where(parent: @parent)
	end
end
