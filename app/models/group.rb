class Group < ApplicationRecord
	validates :tutor, presence: true
	validates :schedule, presence: true
end
