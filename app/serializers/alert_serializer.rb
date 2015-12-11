class AlertSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type, :senderImage, :is_read, :created_at, :isSender
  
  def sender_type
	   object.sender_id ? "User"  : 'system'
  end

  def sender
	   sender_type == "User" ? object.sender.username  : 'stuffmapper.com'
  end

  def senderImage
    sender_type == "User" and object.sender.picture ? object.sender.picture.image.url(:medium) :  false
  end

  def body
	   object.message
  end

  def subject
	   "stuffmapper alert"
  end

  def is_read
    object.read
  end

  def isSender
    scope[:current_user] == object.sender
  end 

end
