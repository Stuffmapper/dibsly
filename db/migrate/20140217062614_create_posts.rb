class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.float :latitude
      t.float :longitude
      t.string :status
      t.string :ip
      t.timestamp :dibbed_until
      t.integer :creator_id

      t.timestamps
    end
  end
end
