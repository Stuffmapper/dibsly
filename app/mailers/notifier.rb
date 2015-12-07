require 'mandrill'
class Notifier < MandrillMailer::TemplateMailer
  default from: "support@stuffmapper.com"


  def password_reset(user)
    mandrill_mail(
      template: 'password-reset',
      to: {email: user.email, name: user.first_name + ' ' + user.last_name },
      vars: {
        'FIRSTNAME'=> user.first_name,
        'CHANGEPASSWORD' =>  root_url + '#/menu/user/email/reset/' + user.password_reset_token
      },
      important: true,
      inline_css: true
    )
  end

  def dibber_notification(dib)
    dibbed_post = dib.post
    user = dib.user
    mandrill_mail(
      template: 'dibber-notification',
      to: {email: user.email, name: user.first_name + ' ' + user.last_name },
      vars: {
        'FIRSTNAME'=> user.first_name,
        'CHATLINK' =>  dib.conversation_url,
        'MYSTUFFLINK' => root_url + '#/menu/mystuff',
        'ITEMIMAGE' => dibbed_post.image_url
      },
      important: true,
      inline_css: true
    )
  end

  def dibber_rejection(dib)
    dibbed_post = dib.post
    user = dib.user
    mandrill_mail(
      template: 'dibs-declined',
      to: {email: user.email, name: user.first_name + ' ' + user.last_name },
      vars: {
        'FIRSTNAME'=> user.first_name,
        'ITEMIMAGE' => dibbed_post.image_url
      },
      important: true,
      inline_css: true
    )
  end

  def lister_notification(dib)
    dibbed_post = dib.post
    user = dibbed_post.creator
    mandrill_mail(
      template: 'lister-notification',
      to: {email: user.email, name: user.first_name + ' ' + user.last_name },
      vars: {
        'FIRSTNAME'=> user.first_name,
        'ITEMIMAGE' => dibbed_post.image_url
      },
      important: true,
      inline_css: true
    )
  end


  def email_verification(user)
    mandrill_mail(
      template: 'email-verification',
      to: {email: user.email, name: user.first_name + ' ' + user.last_name },
      vars: {
        'FIRSTNAME'=> user.first_name,
        'CONFIRMEMAIL' =>  root_url + '#/users/email/' + user.verify_email_token
      },
      important: true,
      inline_css: true
    )
  end
end
