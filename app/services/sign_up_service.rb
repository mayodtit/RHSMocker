class SignUpService < Struct.new(:params, :options)
  def initialize(params, options={})
    super
  end

  # A transaction wraps all actions in this service to ensure that we have no
  # partial or inconsistent records. All errors *should be raised as exceptions*
  # in order to cause a rollback if any part of the service fails.
  def call
    begin
      ActiveRecord::Base.transaction do
        create_member!
        create_session!
        create_subscription! if params[:subscription].try(:[], :payment_token)
        send_welcome_emails!
        send_download_link! if options[:send_download_link]
        notify_other_users!
        do_random_bullshit!
      end
      {
        success: true,
        user: @member,
        auth_token: @auth_token
      }
   rescue ActiveRecord::RecordInvalid => e
     {
       success: false,
       reason: e.record.errors.full_messages.to_sentence
     }
   rescue Exception => e
     {
       success: false,
       reason: e.to_s
     }
    end
  end

  private

  def create_member!
    @member = Member.create!(params[:user])
  end

  def create_session!
    @session = @member.sessions.create!
  end

  def create_subscription!
    begin
      CreateStripeSubscriptionService.new(user: @member,
                                          plan_id: 'bp20',
                                          credit_card_token: params[:subscription][:payment_token],
                                          trial_end: Time.zone.now.pacific.end_of_day + 1.month,
                                          coupon_code: @member.onboarding_group.try(:stripe_coupon_code)).call
    rescue Stripe::CardError => e
      raise e.message
    rescue Stripe::StripeError => e
      raise "There's an error with your credit card, please try another one"
    end
  end

  def send_welcome_emails!
    SendWelcomeEmailService.new(@member).call
    SendConfirmEmailService.new(@member).call
  end

  def send_download_link!
    SendDownloadLinkService.new(@member.phone).call
  end

  def notify_other_users!
    SendEmailToStakeholdersService.new(@member).call
    NotifyReferrerWhenRefereeSignUpService.new(@member.referral_code, @member).call if @member.referral_code.try(:user)
  end

  # TODO - remove when unneeded
  def do_random_bullshit!
    if @member.onboarding_group.try(:name) == 'Mayo Pilot 2'
      MemberTask.create!(title: 'Discharge Instructions Follow Up',
                         description: MAYO_PILOT_2_TASK_DESCRIPTION,
                         due_at: 1.business_day.from_now,
                         service_type: ServiceType.find_by_name('other engagement'),
                         member: @member,
                         subject: @member,
                         owner: @member.pha,
                         creator: Member.robot,
                         assignor: Member.robot)
    end
  end

  MAYO_PILOT_2_TASK_DESCRIPTION = <<-eof
1. Check if you've been assigned a "Review Discharge Plan and save information" task from Paul/Meg
2. Follow up with Paul/Meg if there is no task.
3. Follow "What to do if No Discharge Received" (https://betterpha.squarespace.com/config#/|/stroke-resources/) if you have not been assigned a review discharge form task for patient within 24 hours
  eof
end
