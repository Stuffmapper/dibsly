json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :password_salt, :password_hash, :latitude, :longitude, :status, :ip
  json.url user_url(user, format: :json)
end
