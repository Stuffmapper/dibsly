
class UserSerializer < ActiveModel::Serializer
  attributes :email, :username, :first_name, :last_name, :verified_email, :id, 
  :image_url

  def image_url

  	object.picture ? object.picture.image.url(:medium) : false
  end

end
