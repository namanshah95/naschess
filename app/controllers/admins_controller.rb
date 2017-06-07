class AdminsController < ApplicationController

	def show
		@admin = Admin.find(params[:id])
		require_user!(current_user == @admin)

		@groups = Group.all
	end
end
