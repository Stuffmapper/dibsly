class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :password_salt, :null => false
      t.string :password_hash, :null => false
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :on_the_curb
      t.string :phone_number
      t.string :status, :null => false
      t.string :ip, :null => false

      t.timestamps
    end

    add_index :users, :name, :unique => true
    add_index :users, :email, :unique => true
  end
end
