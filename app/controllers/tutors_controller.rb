class TutorsController < ApplicationController

	def index
		require_user!(admin_logged_in?)
		@tutors = Tutor.all
	end

	def show
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)
	end
end
