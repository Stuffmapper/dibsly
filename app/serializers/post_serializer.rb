class PostSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :image_url, :coords, :image_url, :description

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end
end
