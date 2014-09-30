class Api::V1::MetricsController < Api::V1::ABaseController
  before_filter :authorize_check!

  def index
    items = [
      {
        description: 'Onboarding Call Data',
        path: onboarding_calls_api_v1_dashboard_index_path(format: :csv)
      },
      {
        description: 'Inbound calls',
        path: inbound_api_v1_metrics_path(format: :csv)
      },
      {
        description: 'Inbound calls by week',
        path: inbound_by_week_api_v1_metrics_path(format: :csv)
      },
      {
        description: 'List of emails of paying members',
        path: paying_members_emails_api_v1_metrics_path(format: :csv)
      },
      {
        description: 'List of all onboarding groups and their users',
        path: all_onboarding_groups_and_members_api_v1_metrics_path(format: :csv)
      },
      {
        description: 'Mayo Pilot Overview',
        path: mayo_pilot_overview_api_v1_metrics_path(format: :csv)
      }
    ]

    render_success(metrics: items)
  end

  def all_onboarding_groups_and_members
    csv = CSV.generate do |c|
      c << ['Onboarding Group ID', 'Onboarding Group Name',
            'User ID', 'User First Name', 'User Last Name',
            'User Email', 'User Invitation URL', 'User Sign Up Time']
      OnboardingGroup.all.each do |og|
        og.users.each do |user|
          c << [og.id, og.name, user.id, user.first_name,
                user.last_name, user.email,
                user.invitation_token.nil? ? nil : "http://www.getbetter.com/invites/#{user.invitation_token}",
                user.signed_up_at]
        end
      end
    end

    respond_to { |format| format.csv { send_data csv } }
  end

  def paying_members_emails
    csv = CSV.generate do |c|
      c << ['email']
      StripeExtension.subscriber_emails.each do |email|
        c << [email]
      end
    end

    respond_to { |format| format.csv { send_data csv } }
  end

  def inbound
    task_count = PhoneCallTask.pha.count
    message_count = MessageTask.count

    csv = CSV.generate do |c|
      c << ["type", "count"]
      c << ["Phone", task_count]
      c << ["Message", message_count]
    end

    respond_to { |format| format.csv { send_data csv } }
  end

  def inbound_by_week
    task_epoch = [PhoneCallTask.pha.order('due_at ASC').first.created_at, MessageTask.order('due_at ASC').first.created_at].min
    beginning_of_this_week = Time.now.beginning_of_week :sunday

    processing_week = task_epoch.beginning_of_week :sunday

    i = 0
    csv = CSV.generate do |c|
      c << ["week", "phone", "message"]

      while processing_week <= beginning_of_this_week do
        phone_call_count = PhoneCallTask.pha.where(created_at: processing_week..processing_week.end_of_week(:sunday)).count
        message_count = MessageTask.pha.where(created_at: processing_week..processing_week.end_of_week(:sunday)).count

        c << [i += 1, phone_call_count, message_count]

        processing_week += 1.week
      end
    end

    respond_to { |format| format.csv { send_data csv } }
  end

  def mayo_pilot_overview
    csv = CSV.generate do |c|
      c << ['ID', 'Email', 'Status', 'Onboarding Group Name', 'Signed Up At']
      Member.joins(:onboarding_group).where(onboarding_groups: {mayo_pilot: true}).each do |m|
        c << [m.id, m.email, m.status, m.onboarding_group.name, m.signed_up_at.pacific.strftime('%m/%d/%Y %I:%M %p')]
      end
    end

    respond_to { |format| format.csv { send_data csv } }
  end

  private

  def authorize_check!
    authorize! :read, :metrics
  end
end
