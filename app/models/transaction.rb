class Transaction < ApplicationRecord
  belongs_to :parent
  attr_accessor :price, :num_credits
end
