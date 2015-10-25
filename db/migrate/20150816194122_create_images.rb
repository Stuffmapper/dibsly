class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :imageable, polymorphic: true
      t.timestamps null: false
    end
    add_attachment :images, :image
  end
end
