class Mails::PlainTextJob < Struct.new(:recipient_id, :sender_id, :subject, :text)
  def self.create(recipient_id, sender_id, subject, text)
    Delayed::Job.enqueue(new(recipient_id, sender_id, subject, text))
  end

  def perform
    recipient = Member.find(recipient_id)
    return if recipient.email_confirmed == false
    sender = Member.find(sender_id)
    UserMailer.plain_text_email(recipient, sender, subject, text).deliver
  end
end
