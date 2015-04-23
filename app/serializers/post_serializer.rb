class PostSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude,:image_url, :coords, :image_url,:description, :dibbable, :creator, :on_the_curb, :category

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end

  def dibbable
  	object.available_to_dib?
  end


  def creator
  	User.find(object.creator_id).username
  end

end
