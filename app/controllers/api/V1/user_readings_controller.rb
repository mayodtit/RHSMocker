require 'pusher_module'
include PusherModule

class Api::V1::UserReadingsController < Api::V1::ABaseController
  after_filter :push_random_content, :only => [:mark_read, :dismiss, :read_later]

  def index
    render_success contents:current_user.contents
  end

  def mark_read
    status :read_date, 'read'
  end

  def dismiss
    status :dismiss_date, 'dismissed'
  end

  def read_later
    status :read_later_date, 'readLater' do |user_reading|
      UserReading.increment_counter(:read_later_count, user_reading.id)
    end
  end

  def status attribute, broadcast
    return render_failure("'contents' not part of json", 417) unless params[:contents]
    params[:contents].each do |content|
      user_reading = UserReading.find_or_create_by_user_id_and_content_id(current_user.id, content['id'])
      user_reading.update_attribute attribute, Time.now
      yield user_reading if block_given?
      PusherModule.broadcast(user_reading.user_id, broadcast, user_reading.content_id, user_reading.content.contentsType)
    end
    render_success
  end


  def hasMaxContent
    current_user.user_readings.where(:read_date => nil, :dismiss_date => nil, :read_later_count => 0).count >= 7
  end





  #FOR TESTING ONLY

  def reset
    current_user.user_readings.each do |reading|
      reading.read_date     = nil
      reading.dismiss_date  = nil
      reading.read_later_count = 0
      reading.read_later_date = nil
      reading.save!
    end
    render_success
  end

  def push_random_content
    #create something, add to user_Reading, push it out
    if !hasMaxContent
      randomContentID = Content.getRandomContent()
      randomContent = Content.find(randomContentID)
      UserReading.create(user:current_user, content:randomContent)
      PusherModule.broadcast(current_user.id, 'newcontent', randomContent.id, randomContent.contentsType)
    end
  end

end
