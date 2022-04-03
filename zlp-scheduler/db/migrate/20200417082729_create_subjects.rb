class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.string :subject_code
      t.string :subject_description
      t.references :term, foreign_key: true
      t.timestamps
    end
  end
end
