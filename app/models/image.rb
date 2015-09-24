class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => 'missing',
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :image 
end
