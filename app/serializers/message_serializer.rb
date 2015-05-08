class MessageSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type

  def sender
	object.sender_type == "User" ? object.sender.username  : 'stuffmapper.com'
  end
end
