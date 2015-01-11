class Message < ActiveRecord::Base
  belongs_to :user, :class_name => User, :foreign_key => :sender_id
  belongs_to :user, :class_name => User, :foreign_key => :receiver_id
  attr_readonly :creator_id

  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_READ = 'read']

  default_scope{ order('created_at DESC') }

  validates_presence_of :sender_id
  validates_presence_of :receiver_id
  validates_presence_of :content
  validates :status, inclusion: {in: STATUSES}

  def send_notification(subject, text_content, html_content)
    @receiver = User.find(self.receiver_id)

    require 'mandrill'
    mandrill = Mandrill::API.new '-q-BEin2lOraKbC6UOJsPw'
    message = {"from_name"=>"Stuffmapper",
               "from_email"=>"contactl@stuffmapper.com",
               "subject"=>subject,
               "to"=> [{"email"=>@receiver.email}],
               "text"=>text_content,
               "html"=>html_content,
    }

    async = false
    result = mandrill.messages.send message, async, "Main Pool"
    logger.debug "Mandrill result: #{result}"

  rescue Mandrill::Error => e
    logger.debug "Mandrill error occurred: #{e.class} - #{e.message}"
  end


  # to make sure we don't expose it
  def ip
    ''
  end
end
