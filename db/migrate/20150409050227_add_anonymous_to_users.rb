class AddAnonymousToUsers < ActiveRecord::Migration
  def change
    add_column :users, :anonymous, :boolean, :default => false
  end
end
