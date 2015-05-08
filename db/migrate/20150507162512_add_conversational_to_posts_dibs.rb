class AddConversationalToPostsDibs < ActiveRecord::Migration
  def change
  	add_belongs_to(:mailboxer_conversations, :conversable, polymorphic: true)
  end
end
