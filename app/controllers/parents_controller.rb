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

	def payments
		@parent = Parent.find(params[:id])
		require_user!(admin_logged_in? || (current_user == @parent && !@parent.customer_id.nil?))

		@children = Child.where(parent: @parent)

		query_res = Attendance.where(child: @children, present: true).sort do |a, b|
			b.lesson.datetime <=> a.lesson.datetime
		end

		if query_res.count > 0
			@start = params[:search].present? && params[:search][:start_date].present? ? params[:search][:start_date] : query_res.last.lesson.datetime
			@end = params[:search].present? && params[:search][:end_date].present? ? params[:search][:end_date] : query_res.first.lesson.datetime
		end

		@attendances = query_res.keep_if do |attendance|
			attendance.lesson.datetime >= @start && attendance.lesson.datetime <= @end
		end
	end

	def add_payment_info
		@parent = Parent.find(params[:id])
		require_user!(admin_logged_in? || current_user == @parent)
	end

	def store_card
		@parent = Parent.find(params[:id])
		require_user!(admin_logged_in? || current_user == @parent)

		customer = Stripe::Customer.create(
			email: @parent.email,
			source: params[:stripeSource]
		)

		if @parent.update_attribute(:customer_id, customer.id)
			flash[:notice] = "Card successfully added!"
			redirect_to parent_path(@parent)
		else
			flash.now[:alert] = "Unable to add card!"
			render "add_payment_info"
		end
	end
end
