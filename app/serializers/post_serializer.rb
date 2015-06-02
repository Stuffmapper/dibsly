class PostSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude,
  :coords, :image_url,:description, :dibbable, 
   :creator, :on_the_curb, :category, :published

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end

  def dibbable
  	object.available_to_dib?
  end


  def creator
  	object.user.username
  end

end





