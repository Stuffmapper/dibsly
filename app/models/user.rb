class User < ActiveRecord::Base
  has_many :posts, :class_name => Post, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib, :foreign_key => :creator_id
  has_many :messages, :class_name => Message, :foreign_key => :sender_id
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted']
  
  # attr_accessor allows you to use the password attribute locally, but will not persist it to the database
  attr_accessor :password
  before_save :encrypt_password
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :status, inclusion: {in: STATUSES}
  
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  def self.authenticate(name, password)
    user = find_by_name(name)
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
end
