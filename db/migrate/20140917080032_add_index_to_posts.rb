class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, [:latitude, :longitude, :title, :status, :dibbed_until, :created_at], :name =>'posts_idx'
    add_index :posts, [:status, :dibbed_until, :created_at], :name =>'posts_two_idx'
  end
end
