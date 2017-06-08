class TransactionsController < ApplicationController
	before_action :set_parent

	def index
		require_user!(admin_logged_in? || current_parent == @parent)
	end

	def new
		require_user!(current_parent == @parent)
	end

	def create
	end

	private

	def set_parent
		@parent = Parent.find(params[:parent_id])
	end
end
