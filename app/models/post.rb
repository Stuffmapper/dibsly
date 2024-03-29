class Post < ActiveRecord::Base
  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib
  has_many :alerts
  has_many :reports, through: :dibs
  has_many :pictures, as: :imageable, class_name: "Image"
  belongs_to :current_dib, :class_name => Dib, :foreign_key => :current_dib_id

  #TODO remove has attached file and update tests
  has_attached_file :image,
    :styles => { :medium => "300x300>" }, :default_url => 'missing',
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml"

  #for the comments

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted',
   STATUS_CLAIMED = 'claimed', STATUS_DIBBED = 'dibbed', STATUS_GONE = 'gone',STATUS_LOADING = 'loading' ]

  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  geocoded_by :address


  default_scope { order('created_at DESC') }


  validate :creator_must_be_allowed_to_post_and_dib
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :longitude, :latitude
  validates :status, inclusion: {in: STATUSES}

  after_create do
    self.update_attributes(:dibbed_until => Time.now - 1.minute, :image_url => 'missing')
  end

  def available_to_dib?
    %w(dibbed claimed deleted loading gone).include?(self.status)  ? false : self.dibbed_until <= Time.now
  end



  def create_new_dib (dibber, request_ip='')
    dib = self.dibs.build( :ip => request_ip)
    dibber.dibs << dib
    if dib.save
      set_dibbed_until dib if dib.save
      self.update_attribute(:current_dib, dib)
    end
    return dib
  end

  def creator
    return self.user
  end

  def creator_must_be_allowed_to_post_and_dib
   if not self.user.allowed_to_post_and_dib?
      errors.add(:creator, "Please verify your email to give stuff")
    end
  end

  def current_dibber
    self.current_dib.user if  !self.available_to_dib? and self.current_dib
  end

  def details
     #keep the name the same as dib model (it's used by the conversable model)
   { :image_url => self.image_url,
    :posted => self.published,
    :created => self.created_at,
    :dibbed => self.status == 'dibbed',
    :description => self.description,
    :gone => self.status == 'gone'
  }
  end


  def make_dib_permanent
    self.update_attribute(:status, 'dibbed')
    self.reload
  end

  def permalink
    Rails.application.routes.default_url_options[:host] + '/beta#/menu/post/' + self.id.to_s
  end

  def remove_current_dib
    self.update_attributes({
      :current_dib => nil,
      :dibbed_until => Time.now - 1.minute,
      :status => 'new'})
   self.save!
  end

  def notify_undib  dib
    lister = self.creator
    dibber = dib.user
    body =  "#{dibber.username} has undibbed this item"

    lister.alerts.create(
      :message => body,
      :dib_id => dib.id,
      :post_id => self.id )
    Notifier.notify_undib(dib).deliver_later
  end


  def set_dibbed_until dib
    self.update_attributes( :dibbed_until => dib.valid_until )
  end

  def ip
    ''
  end

  def update_picture picture
    # this is a hack
    # seems like there should be a more elegant
    # way to do this but it should work
    if self.status = 'loading'
      self.status = 'new'
    end
    self.image_url = picture.image.url(:medium)
    self.pictures << picture
    self.save
  end


  protected




end
