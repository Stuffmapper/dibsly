class RemoveCruft2 < ActiveRecord::Migration
  def change
    execute "DROP TABLE #{:mailboxer_notifications} CASCADE"
    execute "DROP TABLE #{:mailboxer_conversations} CASCADE"
    execute "DROP TABLE #{:mailboxer_conversation_opt_outs} CASCADE"
    execute "DROP TABLE #{:mailboxer_receipts} CASCADE"
  end
end
