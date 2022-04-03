class TimeSlot < ApplicationRecord
  belongs_to :cohort
  has_many :conflicts, dependent: :delete_all
end
