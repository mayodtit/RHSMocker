class Api::V1::MetricsController < Api::V1::ABaseController
  before_filter :authorize_check!

  def index
    items = [
      {
        description: 'Member Data csv (previously on Care Portal admin page)',
        url: onboarding_members_api_v1_dashboard_index_url
      },
      {
        description: 'Onboarding Call Data csv (previously on Care Portal admin page)',
        url: onboarding_calls_api_v1_dashboard_index_url
      },
      {
        description: 'Inbound calls csv',
        url: inbound_api_v1_metrics_url
      },
      {
        description: 'Inbound calls by week csv',
        url: inbound_by_week_api_v1_metrics_url
      },
      {
        description: 'List of emails of paying members',
        url: paying_members_emails_api_v1_metrics_url
      }
    ]
    render json: items, root: false
  end

  def paying_members_emails
    csv = CSV.generate do |c|
      c << ['email']
      StripeExtension.subscriber_emails.each do |email|
        c << [email]
      end
    end

    send_data csv, type: 'text/csv', filename: 'paying_members_emails.csv'
  end

  def inbound
    task_count = PhoneCallTask.pha.count
    message_count = MessageTask.count

    csv = CSV.generate do |c|
      c << ["type", "count"]
      c << ["Phone", task_count]
      c << ["Message", message_count]
    end

    send_data csv, type: 'text/csv', filename: 'inbound.csv'
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

    send_data csv, type: 'text/csv', filename: 'inbound_by_week.csv'
  end

  private

  def authorize_check!
    authorize! :read, :metrics
  end
end
