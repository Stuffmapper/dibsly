class AddCurrentDibberToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :current_dib_id, :integer
  end
end
