class TutorsController < ApplicationController
	def show
		@tutor = Tutor.find(params[:id])
	end
end
