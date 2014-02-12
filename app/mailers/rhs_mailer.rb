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

  def assigned_role_email(email, greeting, url, signature)
    mandrill_mail(
      subject: "#{signature} invited you to care for patients with Better!",
      to: { email: email },
      template: 'Assigned Role',
      vars: {
        GREETING: greeting,
        URL: url,
        SIGNATURE: signature
      }
    )
  end
end