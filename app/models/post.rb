class Post < ActiveRecord::Base
  belongs_to :user, :class_name => User
  has_many :dibs, :class_name => Dib, :foreign_key => :post_id
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_readonly :creator_id
  
  STATUSES = [STATUS_NEW = 'new', STATUS_DELETED = 'deleted', STATUS_FINISHED = 'finished', STATUS_DIBBED = 'dibbed']
  
  default_scope order('created_at DESC')

  validates_attachment_presence :image
  validates_presence_of :creator_id
  validates :status, inclusion: {in: STATUSES}
end
