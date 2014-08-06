class Message < ActiveRecord::Base
  belongs_to :user, :class_name => User, :foreign_key => :sender_id
  belongs_to :user, :class_name => User, :foreign_key => :receiver_id
  attr_readonly :creator_id

  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_READ = 'read']

  default_scope order('created_at DESC')

  validates_presence_of :sender_id
  validates_presence_of :receiver_id
  validates_presence_of :text
  validates :status, inclusion: {in: STATUSES}
end
