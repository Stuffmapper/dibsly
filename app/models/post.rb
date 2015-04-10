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
  after_validation :update_image

  def send_message_to_creator (dibber, body, subject)
    dibber.send_message( User.find(self.creator_id), body,subject) 
  end

  def create_new_dib (dibber, request_ip='')
    dib = self.dibs.build
    dib.ip = request_ip
    dib.status = 'new'
    dib.creator_id = dibber.id 
    dib.valid_until = Time.now + Dib.timeSpan
    if dib.save
      self.dibbed_until = dib.valid_until
      self.status == 'dibbed'
      self.dibber_id = dibber.id
      self.save
      send_message_to_creator(dibber, (dibber.username + "'s dibbed your stuff!" ), " Respond to this message to get in contact")
    end
    dib
  end

  def available_to_dib? 
    self.status == 'new' && self.dibbed_until == nil || self.dibbed_until <= Time.now
  end



  def coords
    {'lat'=> self.latitude, 'lng'=> self.longitude }
  end

  def creator
    return User.find(self.creator_id)
  end


  def ip
    ''
  end

  protected

  def update_image

    self.image_url = self.image.url(:medium)
  end

end
