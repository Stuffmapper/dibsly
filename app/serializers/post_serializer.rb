
class PostSerializer < ActiveModel::Serializer
  attributes :id, :isCurrentDibber,  :latitude, :longitude,
  :image_url,:description, :dibbable,
  :creator, :on_the_curb, :category, :published,
  :currentDib,:originalImage, :status, :updated_at, :title, :dibbed_until, :permadib

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

  def isCurrentDibber
    #Later Move this logic to the front end.
    scope[:current_user] ?  object.current_dibber == scope[:current_user] : false
  end


  def originalImage
    object.pictures.last and object.pictures.last.image.url
  end
  def permadib
    object.status == 'dibbed'
  end

  def status
    #Status remains 'new' on object until dib is permeant
    status = object.status
    if %w(claimed deleted loading gone).include?(status)
      #do nothing
    elsif !object.available_to_dib? and object.current_dibber
      #checks
      status = 'dibbed'
    end
    return status 
  end

end
