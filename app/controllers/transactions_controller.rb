class TransactionsController < ApplicationController
	before_action :set_parent

	def index
		require_user!(admin_logged_in? || current_parent == @parent)
		query_res = Transaction.where(parent: @parent).order(created_at: :desc)
		@balance = query_res.sum(:balance_delta)
		@C20 = query_res.sum(:c20_delta)
		@C15 = query_res.sum(:c15_delta)

		if query_res.count > 0
			@start = params[:search].present? && params[:search][:start_date].present? ? params[:search][:start_date] : query_res.last.created_at
			@end = params[:search].present? && params[:search][:end_date].present? ? params[:search][:end_date] : query_res.first.created_at
		end

		@transactions = query_res.where(created_at: @start..@end)
	end

	def new
		require_user!(current_parent == @parent)
		@transaction = Transaction.new
	end

	def create
		tp = transaction_params
		tp[:parent_id] = @parent.id
		tp[:price] = tp[:price].to_i
		tp[:num_credits] = tp[:num_credits].to_i
		if tp[:price] == 20
			tp[:c20_delta] = tp[:num_credits]
		end
		if tp[:price] == 15
			tp[:c15_delta] = tp[:num_credits]
		end
			
		if tp[:num_credits] == 10
			tp[:balance_delta] = tp[:price] * 9
		else
			tp[:balance_delta] = tp[:price] * tp[:num_credits]
		end

		@transaction = Transaction.new(tp)

		if @transaction.balance_delta > 0
			customer = Stripe::Customer.create(
				email: params[:stripeEmail],
				source: params[:stripeToken]
				)

			charge = Stripe::Charge.create(
				customer: customer.id,
				amount: (@transaction.balance_delta * 100).to_i,
				description: "NAS Chess Academy balance refill by " + @parent.name,
				currency: "usd"
				)
		end

		if @transaction.save
			flash[:notice] = "Payment has been made successfully!"
			redirect_to parent_transactions_path(@parent)
		else
			flash.now[:alert] = "Unable to make payment!"
			render "new"
		end

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to new_parent_transaction_path
	end

	private

	def set_parent
		@parent = Parent.find(params[:parent_id])
	end

	def transaction_params
		params.require(:transaction).permit(:description, :num_credits, :price)
	end
end
