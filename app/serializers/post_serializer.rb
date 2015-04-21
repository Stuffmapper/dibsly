class PostSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :image_url, :coords, :image_url, :description, :dibbable

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end

  def dibbable
  	object.available_to_dib?
  end
end
