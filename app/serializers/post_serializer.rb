class PostSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :image_url, :coords

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end
end
