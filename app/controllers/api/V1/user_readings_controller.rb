require 'pusher_module'
include PusherModule

class Api::V1::UserReadingsController < Api::V1::ABaseController

  after_filter :push_random_content, :only => [:mark_read, :dismiss, :read_later]

  def index
    render_success contents:current_user.user_readings
  end

  def mark_read
    user_reading = UserReading.find(params[:id])
    return render_failure("Not Found", 404) unless user_reading
    return render_failure("Not allowed to change this user reading", 401) if user_reading.user_id!=current_user.id
    user_reading.update_attribute :read_date, Time.now
    PusherModule.broadcast(user_reading.user_id, 'read', user_reading.content_id, user_reading.content.contentsType)
    render_success
  end

  def dismiss
    user_reading = UserReading.find(params[:id])
    return render_failure("Not Found", 404) unless user_reading
    return render_failure("Not allowed to change this user reading", 401) if user_reading.user_id!=current_user.id
    user_reading.update_attribute :dismiss_date, Time.now
    PusherModule.broadcast(user_reading.user_id, 'dismissed', user_reading.content_id, user_reading.content.contentsType)
    render_success
  end

  def read_later
    user_reading = UserReading.find(params[:id])
    return render_failure("Not Found", 404) unless user_reading
    return render_failure("Not allowed to change this user reading", 401) if user_reading.user_id!=current_user.id
    user_reading.update_attribute :read_later_date, Time.now
    UserReading.increment_counter(:read_later_count, user_reading.id)
    PusherModule.broadcast(user_reading.user_id, 'readLater', user_reading.content_id, user_reading.content.contentsType)
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
