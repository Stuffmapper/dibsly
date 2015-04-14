class AddUseragreementToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privacy_policy_agreement, :boolean, :default => false
  end
end
