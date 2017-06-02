class Group < ApplicationRecord
	validates :tutor, presence: true
	validates :schedule, presence: true
	attr_accessor :child1
	attr_accessor :child2
	attr_accessor :child3
	attr_accessor :child4
end
