class Dib < ActiveRecord::Base
  belongs_to :user, :class_name => User
  belongs_to :post, :class_name => Post
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished']
  
  @@timeSpan = 3600
  cattr_reader :timeSpan
  
  validates_presence_of :creator_id
  validates_presence_of :post_id
  validates :status, inclusion: {in: STATUSES}
end
