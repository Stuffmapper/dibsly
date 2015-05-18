class ReceiptSerializer < ActiveModel::Serializer
  attributes :body, :subject, :sender, :sender_type, :is_read, :created_at

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

  def is_read
    #pretty hacky ... but whattareyagonnado?
    object.message.receipts.where(:mailbox_type => 'inbox', :receiver_type => "User")[0].is_read
  end
end
