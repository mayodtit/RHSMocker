class SignUpService < Struct.new(:attributes, :options)
  def initialize(attributes, options={})
    super
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        create_member!
        create_session!
        create_subscription!
        send_welcome_email!
        send_confirmation_email!
        send_download_link!
        notify_referrer!
        send_email_to_stakeholders!
        create_mayo_pilot_2_task!
      end
      {
        success: true,
        member: @member
      }
    rescue Exception => e
      {
        success: false,
        reason: e.to_s
      }
    end
  end

  private

  def create_member
    @member = Member.create!(attributes)
  end

  def create_session
    @session = @member.sessions.create!
  end

  def create_subscription
    begin
      CreateStripeSubscriptionService.new(user: @member,
                                          plan_id: 'bp20',
                                          credit_card_token: user_params[:payment_token],
                                          trial_end: Time.zone.now.pacific.end_of_day + 1.month,
                                          coupon_code: coupon_code).call
    rescue Stripe::CardError => e
      render_failure({reason: e.as_json['code'],
                      user_message: e.as_json['message']}, 422) and return
    rescue Stripe::StripeError => e
      render_failure({reason: e.to_s,
                      user_message: "There's an error with your credit card, please try another one"}, 422) and return
    end
  end

  def send_welcome_email
    SendWelcomeEmailService.new(@member).call
  end

  def send_confirmation_email
    SendConfirmEmailService.new(@member).call
  end

  def send_download_link
    SendDownloadLinkService.new(@member.phone).call if options[:send_download_link]
  end

  def notify_referrer
    NotifyReferrerWhenRefereeSignUpService.new(@referral_code, @member).call if @referral_code
  end

  def send_email_to_stakeholders
    if @member.onboarding_group.try(:skip_automated_communications?)
      UserMailer.delay.notify_stakeholders_of_new_signup('mayoclinicpilot@getbetter.com', @member.onboarding_group_id)
    end
  end

  def create_mayo_pilot_2_task
    CreateMayoPilotTaskService.new(@member).call if options[:mayo_pilot_2]
  end
end
