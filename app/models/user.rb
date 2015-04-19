class User < ActiveRecord::Base
  has_many :posts, :class_name => Post, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib, :foreign_key => :creator_id
  has_many :messages, :class_name => Message, :foreign_key => :sender_id
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted']
  
  # attr_accessor allows you to use the password attribute locally, but will not persist it to the database
  attr_accessor :password
  before_save :encrypt_password
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_uniqueness_of :username
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :status, inclusion: {in: STATUSES}
  acts_as_messageable

  def save(*args)
    super
  rescue ActiveRecord::RecordNotUnique => error
    errors[:base] << "Duplicate username or email"
    false
  end

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.status == STATUS_NEW && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.username = auth.info.name
      user.password = auth.credentials.token
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.status = STATUS_NEW
      user.ip = "not_provided"
      user.save!
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def mailboxer_email(object)
    self.email
  end

  # to make sure we don't expose it
  def ip
    ''
  end
end
