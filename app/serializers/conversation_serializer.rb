class ConversationSerializer < ActiveModel::Serializer
  attributes :subject, :created_at, :conversable, :id

  def conversable
	object.conversable.nil? ? "Conversation" : object.conversable.details
  end
end
