class Notifier < ActionMailer::Base
  default from: "no_reply.support@stuffmapper.com"

	def password_reset(user)
		@user = user
		@password_reset_url = root_url + 'user/reset/' + user.password_reset_token
		mail(to: "#{user.first_name}  #{user.last_name} <#{user.email}>",
					subject: "Reset Your Password" )
	end
	

	def dibber_notification(user, dibbed_post)
		@dibbed_post = dibbed_post
		@user = user
		@in_app_chat = root_url + 'user/inbox'
		mail(to: "#{user.first_name}  #{user.last_name} <#{user.email}>",
					subject: "Your latest dib!" )
	end
	
	def email_verification(user)

	end
end
