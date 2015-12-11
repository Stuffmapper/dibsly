class Alert < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	belongs_to :dib
	belongs_to :sender, class_name: "User"

	def mark_as_read
		self.update_attribute(:read, true)
	end
end
