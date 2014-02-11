class RHSMailer < MandrillMailer::TemplateMailer
  default from: (Rails.env.production? ? 'noreply@getbetter.com' : "noreply@#{Rails.env}.getbetter.com")
  default from_name: 'Better'

  def reset_password_email(email, url)
    mandrill_mail(
      subject: 'Reset Password Instructions for Better',
      to: { email: email },
      template: 'Password Reset',
      vars: {
        GREETING: email,
        RESETLINK: url
      }
    )
  end
end