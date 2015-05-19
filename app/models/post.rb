class Post < ActiveRecord::Base
  
  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib, :foreign_key => :post_id
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => "/images/:style/missing.png",
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml"
    
  #for the comments  
  has_one :conversation, :class_name => Mailboxer::Conversation, as: :conversable


  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_readonly :creator_id
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_CLAIMED = 'claimed', STATUS_DIBBED = 'dibbed']
  
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode 
  
  geocoded_by :address


  default_scope { order('created_at DESC') }

  
  validate :creator_must_be_allowed_to_post_and_dib
  validates_attachment_presence :image
  validates_presence_of :creator_id
  validates_presence_of :longitude, :latitude
  validates :status, inclusion: {in: STATUSES}

  after_create do 
    update_image
    self.update_attribute(:dibbed_until, Time.now - 1.minute)
    create_conversation
  end

  def details
     #keep the name the same as dib model (it's used by the conversable model)
   { :image_url => self.image_url,
    :posted => self.published,
    :created => self.created_at,
    :dibbed => self.status == 'dibbed',
    :description => self.description }
  end


  def set_dibbed_until dib
    self.update_attributes( :dibber_id => dib.creator_id,
                            :dibbed_until => dib.valid_until )
  end

  def create_conversation
     self.conversation  = Mailboxer::ConversationBuilder.new({
          :subject    => "Your Latest Dib!",
          :created_at => Time.now,
          :updated_at => Time.now
        }).build
      self.save
  end

  def send_message_to_creator (dibber, body, subject)
    dibber.send_message( User.find(self.creator_id), body,subject) 
  end

  def create_new_dib (dibber, request_ip='')
    dib = self.dibs.build( :ip => request_ip)
    dibber.dibs << dib
    set_dibbed_until dib if dib.save 
    dib
  end

  def remove_current_dib
      self.status = 'new'
      dibber = User.find(self.dibber_id)
      self.dibber_id = nil
      self.dibbed_until = Time.now - 1.minute
      self.save
      send_message_to_creator( dibber, "#{dibber.username} has undibbed your stuff", "Stuff message" )
  end

  def available_to_dib? 
    %w(dibbed claimed deleted).include?(self.status)  ? false : self.dibbed_until <= Time.now
  end

  def make_dib_permanent
    self.update_attribute(:status, 'dibbed')
    self.reload
  end

  def creator_must_be_allowed_to_post_and_dib
   user = User.find(self.creator_id)
   if not user.allowed_to_post_and_dib?
      errors.add(:creator, "Please verify your email to give stuff")
    end
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

    self.update_attribute(:image_url, self.image.url(:medium))

  end


end
