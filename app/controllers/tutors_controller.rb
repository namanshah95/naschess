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

	def lessons
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)

		query_res = Lesson.where(group: Group.where(tutor: @tutor)).order(datetime: :desc)
		
		@start = params[:search].present? && params[:search][:start_date].present? ? params[:search][:start_date] : query_res.last.datetime
		@end = params[:search].present? && params[:search][:end_date].present? ? params[:search][:end_date] : query_res.first.datetime

		@lessons = query_res.where(datetime: @start..@end)
	end
end
