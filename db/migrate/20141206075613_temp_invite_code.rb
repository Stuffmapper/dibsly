class TempInviteCode < ActiveRecord::Migration
  def change
  	add_column :users, :invite_code, :string
  end
end
