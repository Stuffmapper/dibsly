class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :dib
      t.string :description
      t.integer :rating, :default => 5
      t.timestamps null: false
    end
  end
end
