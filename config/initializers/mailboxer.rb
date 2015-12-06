Mailboxer.setup do |config|
  #Enables or disables email sending for Notifications and Messages
  config.uses_emails = true
  #Configures the default `from` address for the email sent for Messages and Notifications of Mailboxer
  config.default_from = "support@stuffmapper.com"
  config.notification_mailer = CustomNotificationMailer
  config.message_mailer = CustomMessageMailer

end