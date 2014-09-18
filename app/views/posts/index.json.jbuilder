json.array!(@posts) do |post|
  json.extract! post, :id, :title, :description, :address, :image_url, :latitude, :longitude, :status, :dibbed_until, :creator_id, :created_at, :on_the_curb
end
