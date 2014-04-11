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
      t.string :status
      t.string :ip

      t.timestamps
    end
  end
end
