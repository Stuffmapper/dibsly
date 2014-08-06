class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :ip
      t.string :status
      t.integer :sender_id, :references => :users
      t.integer :receiver_id, :references => :users
      t.text :message

      t.timestamps
    end
  end
end
