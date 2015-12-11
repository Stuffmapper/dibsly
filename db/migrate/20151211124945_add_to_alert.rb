class AddToAlert < ActiveRecord::Migration
  def change
  	add_column :alerts, :sender_id, :integer
  end
end
