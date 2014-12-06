class UpdatePosts < ActiveRecord::Migration
  def change
  	Post.find_each do |post|
  		user = User.find(post.creator_id)
  		post.contact_email = user.email 
  		post.save 
  	end
  end
end
