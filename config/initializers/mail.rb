ActionMailer::Base.smtp_settings = {
	address: 'smtp.mandrillapp.com',
	port: 587,
	enablestarttls_auto: true,
	user_name: 'stuffmapper@gmail.com',
	password:  'eecqPlsFBCU6tPAyNb6MLg',
	authentication: 'login'
}


ActionMailer::Base.default charset: 'utf-8'