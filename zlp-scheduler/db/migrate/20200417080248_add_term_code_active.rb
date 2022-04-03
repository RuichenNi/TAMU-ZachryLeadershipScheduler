class AddTermCodeActive < ActiveRecord::Migration[5.0]
  def change
    change_table :terms do |t|
      t.string :term_code
      t.boolean :active, default: false
      t.boolean :courses_import_complete, default: false
    end
    add_index :terms, :term_code, unique: true
  end
end