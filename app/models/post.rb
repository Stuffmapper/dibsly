class Post < ActiveRecord::Base
  belongs_to :user, :class_name => User
  has_many :dibs, :class_name => Dib, :foreign_key => :post_id
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => "/images/:style/missing.png",
    :storage => :google_drive,
    :google_drive_credentials => "#{Rails.root}/config/google_drive.yml",
    :google_drive_options => {
        :public_folder_id => '0B28-gAjiQhi6ejZCdkxvOE14NmM',
        :path => proc { |style| "#{image.original_filename}" }
    }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_readonly :creator_id
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_CLAIMED = 'claimed', STATUS_DIBBED = 'dibbed']
  
  default_scope order('created_at DESC')

  validates_attachment_presence :image
  validates_presence_of :creator_id
  validates :status, inclusion: {in: STATUSES}

  # to make sure we don't expose it
  def ip
    ''
  end
end
