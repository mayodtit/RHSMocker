class Api::V1::DashboardController < Api::V1::ABaseController
  before_filter :authorize_user!
  before_filter :authorize_admin!, only: [:onboarding_members, :onboarding_calls]

  def index
    render_success(counts: {
                             members: Member.count,
                             scheduled_phone_calls: -1,
                             contents: Content.count,
                             custom_cards: CustomCard.count,
                             custom_contents: CustomContent.count,
                             programs: Program.count
                           })
  end

  def onboarding_calls
    @data = CSV.generate do |csv|
      csv << %w(email pha created_at scheduled_at)
      ScheduledPhoneCall.where(state: :booked).includes(:user, :owner).find_each do |spc|
        csv << [spc.user.email,
                spc.owner.email,
                format_time_for_csv(spc.created_at),
                format_time_for_csv(spc.scheduled_at)]
      end
    end

    respond_to { |format| format.csv { send_data @data } }
  end

  private

  def authorize_user!
    unless current_user.admin? || current_user.pha?
      raise CanCan::AccessDenied
    end
  end

  def authorize_admin!
    raise CanCan::AccessDenied unless current_user.admin?
  end

  def format_time_for_csv(time)
    time.to_time.getlocal('-08:00').strftime('%m/%d/%Y %I:%M %p')
  end
end
