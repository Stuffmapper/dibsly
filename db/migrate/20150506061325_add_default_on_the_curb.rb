class AddDefaultOnTheCurb < ActiveRecord::Migration
  def change
  	change_column_default :posts, :on_the_curb , false 
  end
end
