class ScheduleToCourse < ApplicationRecord
  belongs_to :schedule
  belongs_to :course
  
  enum day: { Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday:5 }
end
