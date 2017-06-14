class TransactionsController < ApplicationController
	before_action :set_parent

	def index
		require_user!(admin_logged_in? || current_parent == @parent)
		@transactions = Transaction.where(parent: @parent).order(created_at: :desc)
		@balance = @transactions.sum(:balance_delta)
		@C20 = @transactions.sum(:c20_delta)
		@C15 = @transactions.sum(:c15_delta)
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

		if @transaction.save
			flash[:notice] = "Payment has been made successfully!"
			redirect_to parent_transactions_path(@parent)
		else
			flash.now[:alert] = "Unable to make payment!"
			render "new"
		end
	end

	private

	def set_parent
		@parent = Parent.find(params[:parent_id])
	end

	def transaction_params
		params.require(:transaction).permit(:description, :num_credits, :price)
	end
end
