class Api::V1::EnrollmentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_enrollment!, only: %i(show update)
  before_filter :load_referral_code, only: %i(create update)
  before_filter :load_onboarding_group, only: %i(create update)

  def show
    show_resource @enrollment.serializer
  end

  def create
    @enrollment = Enrollment.create enrollment_params
    if @enrollment.errors.empty?
      if params[:enrollment][:business_on_board]
        render_success
        set_uout
        generate_invitation_link
        Mails::SendBusinessOnBoardInvitationEmailJob.create(@enrollment.id, @link)
      else
        hash = {
            nux: { question: Metadata.nux_question_text, answers: NuxAnswer.active.serializer },
            enrollment: @enrollment.serializer
        }
        unless params[:enrollment][:exclude_stories]
          hash.merge!(stories: stories,
                      splash_story: splash_story,
                      question_story: question_story,
                      sign_up_story: sign_up_story)
        end
        render_success(hash)
      end
    else
      render_failure({reason: enrollment_errors}, 422)
    end
  end

  def update
    if @enrollment.update_attributes enrollment_params
      render_success(enrollment: @enrollment.serializer,
                     next_action: next_action,
                     trial_story: trial_or_refer,
                     credit_card_story: credit_card_story,
                     success_story: success_story)
    else
      render_failure({reason: enrollment_errors,
                      user_message: enrollment_errors}, 422)
    end
  end

  def on_board
    obj = find_record
    load_stories!
    if obj.is_a? Member
      session = obj.sessions.create
      @hash.merge!(auth_token: session.auth_token,
                   user_id: obj.id)
      render_success(@hash)
      obj.update_attributes(unique_on_boarding_user_token: nil)
    elsif obj.is_a? Enrollment
      @hash.merge!(sign_up_story:sign_up_story,
                   enrollment: obj.serializer)
      render_success(@hash)
      obj.update_attributes(unique_on_boarding_user_token: nil)
    else
      render_failure({reason: "invalid uout"}, 422)
    end
  end

  private

  def load_stories!
    @hash = {nux: { question: Metadata.nux_question_text, answers: NuxAnswer.active.serializer }}
    unless params[:exclude_stories]
      @hash.merge!(stories: stories,
                   splash_story: splash_story,
                   question_story: question_story)
    end
  end

  def find_record
    records = []
    [Enrollment, Member].each do |class_name|
      obj = class_name.find_by_unique_on_boarding_user_token(params[:unique_on_boarding_user_token]) if params[:unique_on_boarding_user_token]
      records << obj unless obj.nil?
    end
    if records.count == 0
      return nil
    elsif records.count == 1
      return records.first
    else
      return records.select{|record|record.is_a?Member}.first
    end
  end

  def set_uout
    unique_on_boarding_user_token ||= loop do
      new_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
      break new_token unless Enrollment.exists?(unique_on_boarding_user_token: new_token)
    end
    @enrollment.update_attributes(unique_on_boarding_user_token: unique_on_boarding_user_token)
  end

  def generate_invitation_link
    if Rails.env.development?
      @link = "better-dev://nb?cmd='onboarding'+uout='#{@enrollment.unique_on_boarding_user_token}'"
    elsif Rails.env.production?
      @link = "better://nb?cmd='onboarding'+uout='#{@enrollment.unique_on_boarding_user_token}"
    elsif Rails.env.qa?
      @link = "better-qa://nb?cmd='onboarding'+uout='#{@enrollment.unique_on_boarding_user_token}'"
    end
  end

  def load_enrollment!
    @enrollment = Enrollment.find_by_token!(params[:id])
  end

  def load_referral_code
    @referral_code = ReferralCode.find_by_code(params[:enrollment][:code]) if params[:enrollment].try(:[], :code)
    if params[:enrollment].try(:[], :code) && !@referral_code
      render_failure({reason: 'invalid referral code',
                      user_message:'Referral code is invalid'})
    end
  end

  def load_onboarding_group
    @onboarding_group = @referral_code.onboarding_group if @referral_code
  end

  def enrollment_params
    permitted_params.enrollment.tap do |attributes|
      attributes[:onboarding_group] = @onboarding_group if @onboarding_group
      attributes[:referral_code] = @referral_code if @referral_code
    end
  end

  def stories
    NuxStory.enabled.by_ordinal.serializer.as_json
  end

  def next_action
    'credit_card'
  end

  def splash_story
    NuxStory.splash.try(:serializer)
  end

  def question_story
    NuxStory.question.try(:serializer)
  end

  def sign_up_story
    NuxStory.sign_up.try(:serializer)
  end

  def trial_or_refer
    if @referral_code && @referral_code.user_id
      refer_story
    else
      trial_story
    end
  end

  def trial_story
    onboarding_group_or_default_trial_story.tap do |trial|
      trial.enabled = false if (trial && skip_credit_card?)
    end.try(:serializer)
  end

  def refer_story
    NuxStory.refer.tap do |refer|
      refer.enabled = false if (refer && skip_credit_card?)
    end.try(:serializer)
  end

  def onboarding_group_or_default_trial_story
    @onboarding_group.try(:trial_nux_story) || NuxStory.trial
  end

  def credit_card_story
    NuxStory.credit_card.tap do |credit_card|
      credit_card.enabled = false if (credit_card && skip_credit_card?)
    end.try(:serializer)
  end

  def success_story
    NuxStory.sign_up_success.tap do |success|
      success.enabled = false if (success && skip_credit_card?)
    end.try(:serializer)
  end

  def enrollment_errors
    @enrollment.errors.full_messages.to_sentence
  end

  def skip_credit_card?
    @onboarding_group.try(:skip_credit_card?)
  end
end
