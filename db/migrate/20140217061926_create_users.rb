class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_salt
      t.string :password_hash
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :on_the_curb
      t.string :phone_number
      t.string :status
      t.string :ip

      t.timestamps
    end

    add_index :name, :unique => true
    add_index :email, :unique => true
  end
end
