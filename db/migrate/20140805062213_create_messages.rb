class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :ip
      t.string :status
      t.integer :sender_id
      t.integer :receiver_id
      t.text :message

      t.timestamps
    end
  end
end
