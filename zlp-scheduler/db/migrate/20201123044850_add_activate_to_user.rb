class AddActivateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activate, :boolean, default: true
  end
end
