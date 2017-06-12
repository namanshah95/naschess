class Group < ApplicationRecord
	validates :tutor, presence: true
	validates :schedule, presence: true
	belongs_to :tutor
	belongs_to :host, class_name: "Parent"
	attr_accessor :children, :dow, :time
end
