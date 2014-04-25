class Mails::AssignedRoleJob < Struct.new(:user_id, :url, :invitor_name)
  def self.create(user_id, url, invitor_name)
    Delayed::Job.enqueue(new(user_id, url, invitor_name))
  end

  def perform
    user = Member.find(user_id)
    RHSMailer.assigned_role_email(user.email, user.salutation, url, invitor_name).deliver
  end
end
