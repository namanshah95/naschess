class TutorsController < ApplicationController

	def index
		require_user!(admin_logged_in?)
		@tutors = Tutor.all
	end

	def show
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)
		@slots = Array.new
		Group.where(tutor: @tutor).each do |group|
			decode_sched(group).each do |datetime|
				@slots.push({datetime: datetime, group: group})
			end
		end
		@slots.sort_by! do |hash|
			hash[:datetime]
		end
	end
end
