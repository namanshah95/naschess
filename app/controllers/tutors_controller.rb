class TutorsController < ApplicationController

	def index
		require_user!(admin_logged_in?)
		@tutors = Tutor.all
	end

	def show
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)

		@groups = Group.where(tutor: @tutor)
	end

	def lessons
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)

		@groups = Group.where(tutor: @tutor)

		query_res = Lesson.where(group: @groups).order(datetime: :desc)
		
		if query_res.count > 0
			@start = params[:search].present? && params[:search][:start_date].present? ? params[:search][:start_date] : query_res.last.datetime
			@end = params[:search].present? && params[:search][:end_date].present? ? params[:search][:end_date] : query_res.first.datetime
			@group = params[:search].present? && params[:search][:group].present? ? params[:search][:group] : @groups
		end

		@lessons = query_res.where(datetime: @start..@end, group: @group)
	end
end
