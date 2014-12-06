class AddEmailToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :contact_email, :string
  
    
  end
end
