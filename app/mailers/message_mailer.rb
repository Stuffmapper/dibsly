class MessageMailer < MandrillMailer::TemplateMailer
  #Sends and email for indicating a new message or a reply to a receiver.
  #It calls new_message_email if notifing a new message and reply_message_email
  #when indicating a reply to an already created conversation.
  def send_email(sender,message,receiver,dib)
    dibbed_post = dib.post
    mandrill_mail(
      template: 'message-notification',
      to: {email: receiver.email, name: receiver.first_name + ' ' + receiver.last_name },
      vars: {
        'FIRSTNAME'=> receiver.first_name,
        'CHATLINK' =>  dib.conversation_url,
        'MYSTUFFLINK' => root_url + '#/menu/mystuff',
        'ITEMIMAGE' => dibbed_post.image_url,
        'STUFFURL' => dibbed_post.permalink,
        'MESSAGE' => message,
        'USERNAME' => sender.username
      },
      important: true,
      inline_css: true
    )
  end

end