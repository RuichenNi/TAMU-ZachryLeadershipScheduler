class Conflict < ApplicationRecord
  belongs_to :time_slot
  belongs_to :user, optional: true
  belongs_to :course, optional: true
  belongs_to :schedule, optional: true
end
