class CreateDibs < ActiveRecord::Migration
  def change
    create_table :dibs do |t|
      t.string :ip, :null => false
      t.timestamp :valid_until, :null => false
      t.string :status, :null => false
      t.integer :creator_id, :references => :users, :null => false
      t.integer :post_id, :references => :posts, :null => false

      t.timestamps
    end
  end
end
