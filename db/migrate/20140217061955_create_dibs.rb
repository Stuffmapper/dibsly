class CreateDibs < ActiveRecord::Migration
  def change
    create_table :dibs do |t|
      t.string :ip
      t.timestamp :valid_until
      t.string :status
      t.integer :creator_id, :references => :users
      t.integer :post_id, :references => :posts

      t.timestamps
    end
  end
end
