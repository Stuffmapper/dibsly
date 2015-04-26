class AddVerifiedEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :verified_email, :boolean, :default => false
  end

end