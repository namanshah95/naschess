class TutorsController < ApplicationController

	def index
		require_user!(admin_logged_in?)
		@tutors = Tutor.all
	end

	def show
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)

		# Compile ordered list of all timeslots this tutor has
		slots = Array.new
		Group.where(tutor: @tutor).each do |group|
			decode_sched(group).each do |datetime|
				slots.push({datetime: datetime, group: group})
			end
		end
		slots.sort_by! do |slot|
			slot[:datetime]
		end

		# Categorize slots into days of the week
		@dow_slots = Hash.new()
		Date::DAYNAMES.each do |day|
			@dow_slots[day] = Array.new
		end
		slots.each do |slot|
			@dow_slots[slot[:datetime].strftime("%A")].push(slot)
		end

	end

	def lessons
		@tutor = Tutor.find(params[:id])
		require_user!(admin_logged_in? || current_user == @tutor)

		query_res = Lesson.where(group: Group.where(tutor: @tutor)).order(datetime: :desc)
		
		if query_res.count > 0
			@start = params[:search].present? && params[:search][:start_date].present? ? params[:search][:start_date] : query_res.last.datetime
			@end = params[:search].present? && params[:search][:end_date].present? ? params[:search][:end_date] : query_res.first.datetime
		end

		@lessons = query_res.where(datetime: @start..@end)
	end
end
