class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :uin
      t.string :lastname, null:false
      t.string :firstname, null:false
      t.string :email, null:false
      t.string :password_digest

      t.timestamps
    end
  end
end
