ActionMailer::Base.smtp_settings = {
	address: 'smtp.mandrillapp.com',
	port: 587,
	enablestarttls_auto: true,
	user_name: 'stuffmapper@gmail.com',
	password: Rails.application.secrets.mandrill_api_key,
	authentication: 'login'
}


ActionMailer::Base.default charset: 'utf-8'

MandrillMailer.configure do |config|
  config.api_key = Rails.application.secrets.mandrill_api_key
end