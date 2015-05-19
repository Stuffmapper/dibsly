class MessageSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type, :created_at

  def sender
	object.sender_type == "User" ? object.sender.username  : 'stuffmapper.com'
  end
end
