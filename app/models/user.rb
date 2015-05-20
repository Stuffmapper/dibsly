class User < ActiveRecord::Base
  has_secure_password
  has_many :posts, :class_name => Post, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib, :foreign_key => :creator_id
  has_many :messages, :class_name => Message, :foreign_key => :sender_id
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted']
  
  # attr_accessor allows you to use the password attribute locally, but will not persist it to the database
  before_save :downcase_email
  before_save :confirm_email

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_uniqueness_of :username
  #TODO change the database to make username unique on that level

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40},
                       :on => :create


  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :status, inclusion: {in: STATUSES}
  acts_as_messageable

  def save(*args)
    super
  rescue ActiveRecord::RecordNotUnique => error
    errors[:base] << "Duplicate username or email"
    false
  end


  def self.from_omniauth(auth)
    oauth_user = User.find_by_email(auth.info.email)
    if oauth_user
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        oauth_user.provider = auth.provider
        oauth_user.uid = auth.uid
        oauth_user.oauth_token = auth.credentials.token
        oauth_user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        oauth_user.verified_email = true
        oauth_user.save!

        return oauth_user
      end
    else
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.email = auth.info.email
        user.username = auth.info.email.split('@').first+((Integer(auth.uid)%1000000).to_s)
        user.password = auth.credentials.token
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.status = STATUS_NEW
        user.verified_email = true
        user.ip = "not_provided"
        user.save!
        return user 
      end
    end
  end
  

  def mailboxer_email(object)
    self.email
  end


  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48) )
  end

  def confirm_email
     send_verification_email unless self.verified_email
  end

  def send_verification_email
    self.verify_email_token =  SecureRandom.urlsafe_base64(48) 
    Notifier.email_verification(self).deliver_now
  end


  def downcase_email

    self.email = email.downcase
  end
  
  def allowed_to_post_and_dib?
    self.verified_email
  end


  def ip
    ''
  end
end
