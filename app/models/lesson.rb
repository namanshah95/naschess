class Lesson < ApplicationRecord
  belongs_to :group
  attr_accessor :attendance
end
