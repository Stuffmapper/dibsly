
class PostSerializer < ActiveModel::Serializer
  #used for current user posts
  attributes :id, :isCurrentDibber,  :latitude, :longitude,
  :coords, :image_url,:description, :dibbable,
  :creator, :on_the_curb, :category, :published,
  :currentDib,:originalImage, :status, :updated_at, :title
  has_many :dibs


  def currentDib
    dibObject =  scope[:current_user] && object.current_dibber ?  {
      'dibber': object.current_dibber.username,
      'id': object.current_dib.id } : false
  end

  def isCurrentDibber
    scope[:current_user] ?  object.current_dibber == scope[:current_user] : false
  end

  def originalImage
    object.image.url
  end

  def image_url
    object.image.url(:medium)
  end


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
