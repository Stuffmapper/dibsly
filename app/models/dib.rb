class Dib < ActiveRecord::Base
  belongs_to :user, :class_name => User
  belongs_to :post, :class_name => Post
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished']

  # 43200 seconds = 12 hours
  @@timeSpan = 43200
  cattr_reader :timeSpan
  
  validates_presence_of :creator_id
  validates_presence_of :post_id
  validates :status, inclusion: {in: STATUSES}
  validate :cannot_dib_own_post 
  before_validation(on: :create) do
    available_to_dib?
  end



  def cannot_dib_own_post
    if self.creator_id == self.post.creator_id
      errors.add(:dib, "You can't dib your own stuff")
    end
  end

  def available_to_dib?
    if !Post.find(self.post_id).available_to_dib?
      errors.add(:dib, "post not available to dib")
    end
  end

  # to make sure we don't expose it
  def ip
    ''
  end
end
