class AddSubjectToCourses < ActiveRecord::Migration[5.0]
  def change
    change_table :courses do |t|
      t.references :subject, foreign_key: true
    end
  end
end
