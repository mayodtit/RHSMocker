class Api::V1::MetricsController < Api::V1::ABaseController
  before_filter :authorize_check!

  def inbound
    pha = Role.find_by_name!('pha')
    task_count = PhoneCallTask.pha.count
    message_count = MessageTask.count

    csv = CSV.generate do |csv|
      csv << ["type", "count"]
      csv << ["Phone", task_count]
      csv << ["Message", message_count]
    end

    send_data csv, type: 'text/csv', filename: 'inbound.csv'
  end

  def inbound_by_week
    task_epoch = [PhoneCallTask.pha.order('due_at ASC').first.created_at, MessageTask.order('due_at ASC').first.created_at].min
    beginning_of_this_week = Time.now.beginning_of_week :sunday

    processing_week = task_epoch.beginning_of_week :sunday

    i = 0
    csv = CSV.generate do |csv|
      csv << ["week", "phone", "message"]

      while processing_week <= beginning_of_this_week do
        phone_call_count = PhoneCallTask.pha.where(created_at: processing_week..processing_week.end_of_week(:sunday)).count
        message_count = MessageTask.pha.where(created_at: processing_week..processing_week.end_of_week(:sunday)).count

        csv << [i += 1, phone_call_count, message_count]

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