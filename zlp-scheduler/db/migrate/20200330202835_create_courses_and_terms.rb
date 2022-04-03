class CreateCoursesAndTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :terms do |t|
      t.string :name
      t.datetime :opendate
      t.datetime :closedate
      t.timestamps
    end
    
    create_table :courses do |t|
      t.string :full_subject
      t.string :abbreviated_subject
      t.string :course_name
      t.integer :course_number
      t.integer :section_number
      t.datetime :meetingtime_start
      t.datetime :meetingtime_end
      t.string :meeting_days, array: true
      t.string :instructors, array: true
      t.string :meeting_location
      t.references :term, foreign_key: true

      t.timestamps
    end
    
    add_index :courses, :meeting_days, using: 'gin'
    add_index :courses, :instructors, using: 'gin'
  end
end
