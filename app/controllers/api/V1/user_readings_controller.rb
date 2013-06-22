require 'pusher_module'
include PusherModule

class Api::V1::UserReadingsController < Api::V1::ABaseController

  def index
    render_success user_readings:current_user.user_readings.for_timeline
  end

  def inbox
    page = Integer(params[:page] || 2)
    per_page = Integer(params[:per_page] || 10)

    unread = current_user.message_statuses.unread.map { |message_status|
      render_message_into_common_format(message_status)
    } | current_user.user_readings.unread

    read = current_user.message_statuses.read.map { |message_status|
      render_message_into_common_format(message_status)
    } | current_user.user_readings.saved

    unread.sort_by!{|obj| obj[:created_at]}
    read.sort_by!{|obj| obj[:created_at]}

    render_success({unread:unread, read:( read.slice( (page-1)*per_page, per_page ) || []) })

  end

  def render_message_into_common_format message_status
    {
      :read_date=>(message_status.status=="read" ? message_status.updated_at : nil),
      :dismiss_date=>nil,
      :read_later_date=>nil,
      :title=> message_status.message.title,
      :contentsType=>"Message",
      :message_id=>message_status.message.id,
      :created_at=>message_status.message.created_at
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
      PusherModule.broadcast(user_reading.user_id, broadcast, user_reading.content_id, user_reading.content.contentsType)
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
    #create something, add to user_Reading, push it out
    if !hasMaxContent
      contents = {}
      current_user.keywords.each do |mv|
        mv[0].contents.each do |content|
          if contents.has_key? content
            contents[content]+=mv[1]
          else
            contents[content] = mv[1]
          end
        end
      end
      contents = contents.sort_by{|x,y| contents[x]<=>contents[y]}
      content_id = nil
      contents.each do |content|
        unless current_user.user_readings.map{|ur| ur.content_id}.include? content[0].id
          content_id = content[0].id
          break
        end
      end

      content_id||=Content.getRandomContent()
      content = Content.find(content_id)
      UserReading.create(user:current_user, content:content)
      PusherModule.broadcast(current_user.id, 'newcontent', content.id, content.contentsType)
    end
  end

end
