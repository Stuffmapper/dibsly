
class PostSerializer < ActiveModel::Serializer
  #used for current user posts
  attributes :id, :isCurrentDibber,  :latitude, :longitude,
  :coords, :image_url,:description, :dibbable,
  :creator, :on_the_curb, :category, :published,
  :currentDib,:originalImage, :status, :updated_at, :title

  def coords
    {'latitude'=> self.latitude, 'longitude'=> self.longitude }
  end

  def currentDib
    dibObject =  scope[:current_user] && object.current_dibber ?  {
      'dibber': object.current_dibber.username,
      'id': object.current_dib.id } : false
  end

  def creator
    object.user.username
  end

  def dibbable
    object.available_to_dib?
  end

  # def dibs
  #   scope[:current_user]  === object.user and obj.dibs
  # end

  def isCurrentDibber
    #Later Move this logic to the front end.
    scope[:current_user] ?  object.current_dibber == scope[:current_user] : false
  end

  def originalImage
    object.pictures.last and object.pictures.last.image.url
  end



end
