json.array!(@posts) do |post|
  json.extract! post, :id, :title, :description, :image_url, :latitude, :longitude, :status, :ip, :dibbed_until, :creator_id
  json.url post_url(post, format: :json)
end
