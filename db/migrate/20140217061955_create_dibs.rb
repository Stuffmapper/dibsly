class CreateDibs < ActiveRecord::Migration
  def change
    create_table :dibs do |t|
      t.string :ip
      t.timestamp :valid_until
      t.string :status
      t.integer :creator_id
      t.integer :post_id

      t.timestamps
    end
  end
end
