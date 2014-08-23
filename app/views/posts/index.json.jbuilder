json.array!(@posts) do |post|
  post.image_url = post.image.url(:medium)
  json.extract! post, :id, :title, :description, :address, :image_url, :latitude, :longitude, :status, :dibbed_until, :creator_id, :created_at
end
