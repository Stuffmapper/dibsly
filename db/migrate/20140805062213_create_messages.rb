class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :ip, :null => false
      t.string :status, :null => false
      t.integer :sender_id, :references => :users, :null => false
      t.string :sender_name, :null => false
      t.integer :receiver_id, :references => :users, :null => false
      t.string :receiver_name, :null => false
      t.text :content, :null => false

      t.timestamps
    end
  end
end
