class DibSerializer < ActiveModel::Serializer
  attributes :id, :status, :dibber, :current_dibber

  def dibber
    object.user.username
  end


  def current_dibber
    object.post.dibber_id  == object.user.id
  end



  # def creator
  # 	User.find(object.creator_id).username
  # end

end
