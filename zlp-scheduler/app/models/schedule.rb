class Schedule < ApplicationRecord
  belongs_to :user
  has_many :schedule_to_courses, dependent: :delete_all
  has_many :courses, through: :schedule_to_courses
end
