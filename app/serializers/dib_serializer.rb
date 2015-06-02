class DibSerializer < ActiveModel::Serializer
  attributes :id, :status, :dibber, :current_dibber, :conversation_url

  def dibber
    object.user.username
  end

  def current_dibber
    object.post.dibber_id  == object.user.id
  end

  def conversation_url
    object.conversation_url
  end

end
