class AddReasonToScheduleToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :schedule_to_courses, :reason, :string
  end
end
