class Api::V1::UserReadingsController < Api::V1::ABaseController

  def index
    render_success user_readings:current_user.user_readings.for_timeline
  end

  def inbox
    push_content
    if params[:type] == 'carousel'
      render_success(unread: unread_items)
    elsif params[:type] == 'timeline'
      render_success(read: read_items)
    else
      render_success(unread: unread_items, read: read_items)
    end
  end

  def render_message_into_common_format message_status
    {
      :read_date=>(message_status.status=="read" ? message_status.updated_at : nil),
      :dismiss_date=>nil,
      :read_later_date=>nil,
      :title=> message_status.message.title,
      :content_type=>"Message",
      :message_id=>message_status.message.id,
      :created_at=>message_status.message.created_at,
      :encounter_id => message_status.message.encounter.id
    }
  end

  def mark_read
    status :read_date, 'read'
  end

  def dismiss
    status :dismiss_date, 'dismissed'
  end

  def save
    status :save_date, 'saved' do |user_reading|
      UserReading.increment_counter(:save_count, user_reading.id)
    end
  end

  def status attribute, broadcast
    return render_failure({reason:"'contents' not part of json"}, 412) unless params[:contents]
    errors = []
    params[:contents].each do |content|
      unless Content.find_by_id(content['id'])
        errors << "Content with id=#{content['id']} not found"
        next
      end

      user_reading = UserReading.find_or_create_by_user_id_and_content_id(current_user.id, content['id'])
      user_reading.update_attribute attribute, Time.now
      yield user_reading if block_given?
      PusherJob.new.push_status(user_reading.user_id, user_reading.id, broadcast)
    end
    push_content
    return render_failure({reason:errors.to_sentence}, 404) unless errors.empty?
    render_success
  end


  def hasMaxContent
    current_user.user_readings.unread.count >= 7
  end

  #FOR TESTING ONLY

  def reset
    current_user.user_readings.each do |reading|
      reading.read_date     = nil
      reading.dismiss_date  = nil
      reading.save_count = 0
      reading.save_date = nil
      reading.save!
    end
    render_success
  end

  def push_content
    PusherJob.new.push_content(current_user.id)
  end

  private

  def read_items
    read = current_user.message_statuses.read.map { |message_status|
      render_message_into_common_format(message_status)
    } | current_user.user_readings.saved.order('priority DESC')
    read
  end

  def unread_items
    unread = current_user.message_statuses.unread.map { |message_status|
      render_message_into_common_format(message_status)
    } | current_user.user_readings.not_saved_not_dismissed.order('priority DESC')
    unread
  end
end
