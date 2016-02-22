class RemoveCruft < ActiveRecord::Migration
  def change
    #Tables
    remove_foreign_key "mailboxer_receipts", :name => "receipts_on_notification_id"
    remove_foreign_key "mailboxer_notifications", :name => "notifications_on_conversation_id"

    #Indexes
    drop_table :messages
    # drop_table :mailboxer_receipts
    # drop_table :mailboxer_conversations
    # drop_table :mailboxer_notifications
  end
end
