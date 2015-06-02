class Notifier < ActionMailer::Base
  default from: "no_reply.support@stuffmapper.com"

	def password_reset(user)
		@user = user
		@password_reset_url = root_url + 'user/reset/' + user.password_reset_token
		mail(to: "#{user.first_name}  #{user.last_name} <#{user.email}>",
					subject: "Reset Your Password" )
	end
	

	def dibber_notification(dib)
		@dibbed_post = dib.post
		@user = dib.user
		@in_app_chat = dib.conversation_url
		mail(to: "#{@user.first_name}  #{@user.last_name} <#{@user.email}>",
					subject: "Your latest dib!" )
	end

	def email_verification(user)
		@user = user
		@email_verification_url = root_url + 'user/email/' + user.verify_email_token
		mail(to: "#{user.first_name}  #{user.last_name} <#{user.email}>",
					subject: "Welcome to Stuffmapper! Please verify your email" )
	end
end
