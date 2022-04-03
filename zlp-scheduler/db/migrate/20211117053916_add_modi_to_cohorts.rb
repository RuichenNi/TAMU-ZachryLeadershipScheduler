class AddModiToCohorts < ActiveRecord::Migration[5.2]
  def change
    add_column :cohorts, :modi, :boolean
  end
end
