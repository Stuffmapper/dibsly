class ChangeNamesOnUsers < ActiveRecord::Migration
  def change

  add_column :users, :first_name, :string
  add_column :users, :last_name, :string
  add_column :users, :username, :string, unique: true
  remove_column :users, :name
 
  end
end
