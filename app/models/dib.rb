class Dib < ActiveRecord::Base
  acts_as_messageable
  has_many :alerts
  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  belongs_to :post, :class_name => Post, :foreign_key => :post_id
  has_one :report

  #for the inital conversation

  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished']

  #900 seconds = 15 minutes
  @@timeSpan = 900
  cattr_reader :timeSpan

  after_initialize do
    self.status = 'new'
    self.valid_until = Time.now + Dib.timeSpan
  end

  after_create do
    initiate_conversation
  end

  validates_presence_of :creator_id
  validates_presence_of :post_id
  validate :creator_must_be_allowed_to_post_and_dib
  validates :status, inclusion: {in: STATUSES}
  validate :cannot_dib_own_post
  before_validation(on: :create) do
    available_to_dib?
  end

  def details
    self.post.details
  end


  def mailboxer_email(object)
    "dibber_chat@stuffmapper.com"
  end

  def conversation_url
    Rails.application.routes.default_url_options[:host] + '#/user/chat/' + self.id.to_s
  end

  def initiate_conversation
    send_message_to_dibber
    notify_poster
  end

  def contact_other_party sender, body
    self.post.reload
    #figur out 
    if sender == self.post.current_dibber and self.valid_until >= Time.now
      self.post.make_dib_permanent
    end
    if sender == self.user
      receipient = self.post.creator
    else
      receipient = self.user
    end
    receipient.alerts.create(
      :message => body, 
      :dib_id => self.id,
      :post_id => self.post_id,
      :sender_id => sender.id  
    )
    MessageMailer.send_email(user,body,receipient,self).deliver_later
  end

  def remove_as_dibber
    if self.post.current_dibber == self.user
      self.user.alerts.create(
        :message => "Removed as dibber", 
        :dib_id => self.id,
        :post_id => self.post_id )
      Notifier.dibber_rejection(self).deliver_now 
      self.post.update_attributes({:current_dib => nil, :dibbed_until => Time.now - 1.minute, :status => 'new' })
    end
  end



  def cannot_dib_own_post
    if self.creator_id == self.post.creator_id
      errors.add(:dib, "You can't dib your own stuff")
    end
  end


  def send_message_to_dibber
    #only used for initial conversation
    Notifier.dibber_notification(self).deliver_later
  end

  def notify_poster
    poster = self.post.creator
    dibber = self.user
    poster.alerts.create(
      :message => "#{dibber.username} dibbed #{self.post.title}" ,
      :dib_id => self.id,
      :post_id => self.post_id )
    Notifier.lister_notification(self).deliver_later
  end

  def available_to_dib?
    if !Post.find(self.post_id).available_to_dib?
      errors.add(:dib, "post not available to dib")
    end
  end

  def creator_must_be_allowed_to_post_and_dib
   user = User.find(self.creator_id)
   if not user.allowed_to_post_and_dib?
      errors.add(:creator, "Please verify your email to dib")
    end
  end

  # to make sure we don't expose it
  def ip
    ''
  end
end
