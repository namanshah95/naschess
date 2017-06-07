class ParentsController < ApplicationController
	
	def index
		require_user!(admin_logged_in?)
		@parents = Parent.all
	end

	def show
		@parent = Parent.find(params[:id])
		require_user!(admin_logged_in? || current_user == @parent)

		@children = Child.where(parent: @parent)
	end
end
