class MessageSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type

  def sender

	object.sender.username
  end
end
