class Lesson < ApplicationRecord
  validates :group, presence: true
  belongs_to :group
  attr_accessor :attendance
end
