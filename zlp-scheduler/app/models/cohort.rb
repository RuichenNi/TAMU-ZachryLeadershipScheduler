class Cohort < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :time_slots, dependent: :destroy
    has_one :term
end
