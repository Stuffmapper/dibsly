class UploadImageJob < ActiveJob::Base
  queue_as :default

  def perform post, image
    post.image = image
    post.save
  end
end
