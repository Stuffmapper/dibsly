class Dib < ActiveRecord::Base
  acts_as_messageable
  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  belongs_to :post, :class_name => Post, :foreign_key => :post_id
  
  #for the inital conversation
  has_one :conversation, :class_name => Mailboxer::Conversation, as: :conversable
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished']

  # 1800 seconds = 30 minutes
  @@timeSpan = 1800
  cattr_reader :timeSpan
  
  after_initialize do 
    self.status = 'new'
    self.valid_until = Time.now + Dib.timeSpan
  end

  after_create do
    create_conversation
    initiate_conversation
  end
  # after_save do
  #   initiate_conversation
  # end

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

  def initiate_conversation
    send_message_to_dibber 
    notify_poster 
  end

  def contact_other_party user, body
    if user == self.user and self.valid_until >= Time.now and self.post.status =='new' 
      self.post.make_dib_permanent
    end 
    user.reply_to_conversation(self.conversation, body)
  end

  def notify_undib
    dibber = self.user
    body =  "#{dibber.username} has undibbed your stuff"
    self.reply_to_conversation(self.conversation, body)
  end



  def cannot_dib_own_post
    if self.creator_id == self.post.creator_id
      errors.add(:dib, "You can't dib your own stuff")
    end
  end

  def create_conversation
    self.conversation = Mailboxer::ConversationBuilder.new({
          :subject    => "Your Latest Dib!",
          :created_at => Time.now,
          :updated_at => Time.now
        }).build
  end

  def send_message_to_dibber 
    Notifier.dibber_notification(self).deliver_now
  end

  def notify_poster 
    poster = self.post.creator
    dibber = self.user
    self.start_existing_conversation(self.conversation,[poster],"#{dibber.username}'s dibbed your stuff! #{dibber.username} will be getting in contact in the next 30 minutes to keep their dib!" , "Your Stuff's been Dibbed!")
    self.conversation.add_participant(dibber)
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


