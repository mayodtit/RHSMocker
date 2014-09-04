class Cohort < ActiveRecord::Base
  serialize :raw_data, Hash

  attr_accessible :started_at, :ended_at, :total_users, :users_with_message,
                  :users_with_service, :converted_users, :raw_data

  def self.create_for_date(date)
    started_at = date.pacific.beginning_of_day
    ended_at = date.pacific.end_of_day

    users = Member.signed_up_consumer
                  .where('signed_up_at >= ?', started_at)
                  .where('signed_up_at <= ?', ended_at)

    users_with_message = users.joins(:messages).uniq
    users_with_service = users.select{|m| m.has_service_task? || m.has_request_task?}
    converted_users = users.joins(:member_state_transitions)
                           .where(member_state_transitions: {to: :premium})
                           .uniq

    upsert_attributes({
      started_at: started_at,
      ended_at: ended_at
    }, {
      total_users: users.count,
      users_with_message: users_with_message.count,
      users_with_service: users_with_service.count,
      converted_users: converted_users.count,
      raw_data: {
        total_users_ids: users.map(&:id),
        users_with_message_ids: users_with_message.map(&:id),
        users_with_service_ids: users_with_service.map(&:id),
        converted_users_ids: converted_users.map(&:id)
      }
    })
  end

  def self.create_daily_since(time)
    while time < Time.now
      create_for_date(time)
      time = time + 1.day
    end
  end
end
