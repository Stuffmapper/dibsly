class Post < ActiveRecord::Base

  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib
  has_many :reports, through: :dibs
  belongs_to :current_dib, :class_name => Dib, :foreign_key => :current_dib_id
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => 'missing',
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml"

  #for the comments
  has_one :conversation, :class_name => Mailboxer::Conversation, as: :conversable

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_CLAIMED = 'claimed', STATUS_DIBBED = 'dibbed', STATUS_GONE = 'gone',]

  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  geocoded_by :address


  default_scope { order('created_at DESC') }


  validate :creator_must_be_allowed_to_post_and_dib
  validates_presence_of :user
  validates_presence_of :longitude, :latitude
  validates :status, inclusion: {in: STATUSES}

  after_create do
    create_conversation
    update_image
    self.update_attribute(:dibbed_until, Time.now - 1.minute)
  end

  def details
     #keep the name the same as dib model (it's used by the conversable model)
   { :image_url => self.image.url(:medium),
    :posted => self.published,
    :created => self.created_at,
    :dibbed => self.status == 'dibbed',
    :description => self.description,
    :gone => self.status == 'gone'
  }
  end
  def permalink
    '/post/' + self.id.to_s
  end

  def current_dibber
    self.current_dib.user unless !self.current_dib
  end


  def set_dibbed_until dib
    self.update_attributes( :dibbed_until => dib.valid_until )
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
    self.status = 'dibbed'
    self.save
    set_dibbed_until dib if dib.save
    self.update_attribute(:current_dib, dib)
    dib
  end

  def remove_current_dib
      self.current_dib.notify_undib
      self.update_attributes({
        :current_dib => nil,
        :dibbed_until => Time.now - 1.minute,
        :status => 'new'})
     self.save!
  end

  def delete_post
    self.update_attributes({
      status: 'deleted'
      })
    self.save!
  end  

  def available_to_dib?
    %w(dibbed claimed deleted).include?(self.status)  ? false : self.dibbed_until <= Time.now
  end

  def make_dib_permanent
    self.update_attribute(:status, 'dibbed')
    self.reload
  end

  def creator_must_be_allowed_to_post_and_dib
   if not self.user.allowed_to_post_and_dib?
      errors.add(:creator, "Please verify your email to give stuff")
    end
  end


  def coords
    {'lat'=> self.latitude, 'lng'=> self.longitude }
  end

  def creator
    return self.user
  end


  def ip
    ''
  end

  protected

  def update_image

    self.update_attribute(:image_url, self.image.url(:medium))

  end


end
