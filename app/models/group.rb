class Group < ApplicationRecord
	validates :tutor, presence: true
	validates :schedule, presence: true
	belongs_to :tutor
	attr_accessor :children
end
