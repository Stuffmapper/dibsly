class Add < ActiveRecord::Migration
  def change
    add_index :alerts, [ :user_id, :post_id, :sender_id, :dib_id ]
    add_index :dibs, [ :post_id, :creator_id ]
    add_index :posts, [ :dibber_id ]
    add_index :users, [ :username, :oauth_token ]
    add_index :images, [ :imageable_id ]
  end
end
