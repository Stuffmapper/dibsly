class Post < ActiveRecord::Base
  
  belongs_to :user, :class_name => User
  has_many :dibs, :class_name => Dib, :foreign_key => :post_id
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => "/images/:style/missing.png",
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_readonly :creator_id
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_CLAIMED = 'claimed', STATUS_DIBBED = 'dibbed']
  
  default_scope { order('created_at DESC') }

  validates_attachment_presence :image
  validates_presence_of :creator_id
  validates_presence_of :longitude, :latitude
  validates :status, inclusion: {in: STATUSES}

  # to make sure we don't expose it

        #grr!!!!!!
      #if ((post.image != nil) && (post.image_url == nil))
        #post.image_url = post.image.url(:medium)
       # post.save
      #end

  def coords
    {'lat'=> self.latitude, 'lng'=> self.longitude }
  end



  def ip
    ''
  end
end
