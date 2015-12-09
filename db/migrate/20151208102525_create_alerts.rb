class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :user
      t.string :message
      t.string :url
      t.boolean :read, :default => false
      t.timestamps 
    end
  end
end
