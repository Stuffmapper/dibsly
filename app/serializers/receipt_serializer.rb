class ReceiptSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type

  def sender_type
	object.message.sender_type 
  end

  def sender
	object.message.sender_type == "User" ? object.message.sender.username  : 'stuffmapper.com'
  end

  def body
	object.message.body
  end

  def subject
	object.message.subject 
  end
end
