class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :on_the_curb
      t.string :phone_number
      t.string :status, :null => false
      t.string :ip, :null => false
      t.timestamp :dibbed_until
      t.integer :creator_id, :references => :users, :null => false
      t.integer :dibber_id, :references => :users

      t.timestamps
    end
  end
end
