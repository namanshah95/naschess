class Attendance < ApplicationRecord
  belongs_to :lesson
  belongs_to :child
end
