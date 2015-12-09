Mailboxer.setup do |config|
  #Enables or disables email sending for Notifications and Messages
  config.uses_emails = false
  #Configures the default `from` address for the email sent for Messages and Notifications of Mailboxer
  config.default_from = "support@stuffmapper.com"
end