class Dib < ActiveRecord::Base
  belongs_to :user, :class_name => User, :foreign_key => :creator_id
  belongs_to :post, :class_name => Post
  
  #for the inital conversation
  has_one :conversation, :class_name => Mailboxer::Conversation, as: :conversable
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished']

  # 43200 seconds = 12 hours
  @@timeSpan = 43200
  cattr_reader :timeSpan
  
  after_initialize do 
    self.status = 'new'
    self.valid_until = Time.now + Dib.timeSpan
    create_conversation
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
  acts_as_messageable

  def mailboxer_email(object)
    "dibber_chat@stuffmapper.com"
  end

  def initiate_conversation
    send_message_to_dibber 
    notify_poster 
  end


  def cannot_dib_own_post
    if self.creator_id == self.post.creator_id
      errors.add(:dib, "You can't dib your own stuff")
    end
  end

  def create_conversation
    convo = Mailboxer::ConversationBuilder.new({
          :subject    => "Your Latest Dib!",
          :created_at => Time.now,
          :updated_at => Time.now
        }).build
    self.conversation = convo
  end

  def send_message_to_dibber 
    Notifier.dibber_notification(self).deliver_now
  end

  def notify_poster 
    poster = self.post.creator
    self.send_message( poster,
     "#{poster.username}'s dibbed your stuff! #{poster.username} will be getting in contact in the next 30 minutes to keep their dib!" , "Your Stuff's been Dibbed!")
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
    # if dib.save
    #   #this goes to dib
    #   send_message_to_creator(dibber, (dibber.username + "'s dibbed your stuff!" ), " Respond to this message to get in contact")
    #   #this goes to dib
    #   send_message_to_dibber (dibber)
    # end

