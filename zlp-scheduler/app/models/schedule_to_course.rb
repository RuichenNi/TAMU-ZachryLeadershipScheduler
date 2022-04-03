class ScheduleToCourse < ApplicationRecord
  belongs_to :schedule
  belongs_to :course
end
