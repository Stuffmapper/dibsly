class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.decimal :latitude
      t.decimal :longitude
      t.string :status
      t.string :ip
      t.timestamp :dibbed_until
      t.integer :creator_id

      t.timestamps
    end
  end
end
