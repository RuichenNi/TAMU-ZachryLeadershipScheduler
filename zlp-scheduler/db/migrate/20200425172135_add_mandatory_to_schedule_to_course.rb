class AddMandatoryToScheduleToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :schedule_to_courses, :mandatory, :boolean, default: false
  end
end
