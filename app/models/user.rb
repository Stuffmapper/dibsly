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
  before_save :downcase_email

  def save(*args)
    super
  rescue ActiveRecord::RecordNotUnique => error
    errors[:base] << "Duplicate username or email"
    false
  end

  def self.authenticate(username, password)
    user = find_by_username(username) || find_by_email(username.downcase)
    if user && user.status == STATUS_NEW && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
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

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48) )
  end


  def downcase_email

    self.email = email.downcase
  end

  def ip
    ''
  end
end
