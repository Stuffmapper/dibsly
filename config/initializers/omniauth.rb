
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1497795170480964', '79eb3898f556146e5645f666cbb27f6b' #ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end