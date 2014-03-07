json.array!(@dibs) do |dib|
  json.extract! dib, :id, :ip, :valid_until, :status, :creator_id, :post_id
  json.url dib_url(dib, format: :json)
end
