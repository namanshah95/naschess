class AdminsController < ApplicationController

	def show
		@admin = Admin.find(params[:id])
		require_user!(current_user == @admin)

        @activities = Activity.order(created_at: :desc)
	end
end
