class AddDibpostidsToAlerts < ActiveRecord::Migration
  def change
  	add_reference :alerts, :post
  	add_reference :alerts, :dib
  	remove_column :alerts, :url
  end
end
