class EmailVerificationToken < ActiveRecord::Migration
  def change
  	add_column :users, :verify_email_token, :string
	add_index :users, :verify_email_token
  end
end

