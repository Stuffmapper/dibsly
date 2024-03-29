class User < ActiveRecord::Base
  has_secure_password
  has_many :posts, :class_name => Post, :foreign_key => :creator_id
  has_many :dibs, :class_name => Dib, :foreign_key => :creator_id
  has_many :messages, :class_name => Message, :foreign_key => :sender_id
  has_many :reports, through: :dibs
  has_many :alerts
  has_one :picture, as: :imageable, class_name: "Image"
  #has_many :dib_posts, through: :dibs, :source => :post
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted']

  before_save :downcase_email
  before_save :update_email_verify_token
  after_save :confirm_email

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :username, :uniqueness => {:case_sensitive => false}
  #TODO change the database to make username unique on that level

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password, length: { minimum: 6 }, presence: true, on: :create


  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :status, inclusion: {in: STATUSES}

  def save(*args)
    super
  rescue ActiveRecord::RecordNotUnique => error
    errors[:base] << "Duplicate username or email"
    false
  end


  def self.from_omniauth(auth,request)
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
        user.username = self.create_username auth
        user.password = auth.credentials.token[0..35]
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.status = STATUS_NEW
        user.verified_email = true
        user.ip = request ? request.remote_ip : "not_provided"
        user.save!
        return user
      end
    end
  end

  def allowed_to_post_and_dib?
    self.verified_email
  end

  def self.create_username auth
    username = !auth.info.nickname.nil? ? auth.info.nickname : auth.info.first_name + auth.info.last_name
    number = 0;
    while self.find_by_username username
      number += 1
      username += number.to_s
    end
    username
  end

  def dib_posts
    #active dibs
    (self.dibs.select {|x| x.post != nil and x.post.current_dib == x and !x.post.available_to_dib? }).collect { |y| y.post }
  end

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48) )
  end


  def mailboxer_email(object)
    self.email
  end

  def confirm_email
    Notifier.email_verification(self).deliver_now unless self.verified_email
  end

  def update_email_verify_token
    self.verify_email_token = SecureRandom.urlsafe_base64(48) unless self.verified_email
  end

  def resend_email_verification
    self.save #already resends when saved and not verified
  end

  def downcase_email

    self.email = email.downcase
  end



  def update_picture picture
    self.picture = picture
    self.save
  end


  def ip
    ''
  end
end
