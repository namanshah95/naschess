class AdminsController < ApplicationController

	def show
		@admin = Admin.find(params[:id])
		@groups = Group.all
	end
end
