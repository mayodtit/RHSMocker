class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_users!, only: :index

  def index
    render_success(consult: @consult.serializer,
                   messages: @consult.messages.serializer(shallow: true),
                   users: @users.serializer)
  end

  def create
    create_resource(@consult.messages, message_attributes)
    if send_robot_response?
      send_robot_response!
    elsif needs_off_hours_response?
      send_after_hours_response!
    end
  end

  private

  def load_consult!
    @consult = if params[:consult_id] == 'current'
                 @user.master_consult
               else
                 Consult.find(params[:consult_id])
               end
    raise ActiveRecord::RecordNotFound unless @consult
    authorize! :manage, @consult
  end

  def load_users!
    @users = @consult.users.to_a
    @users = @users << @user.pha if @user.pha
    @users = @users.uniq
  end

  def message_attributes
    params.require(:message).permit(:text, :image, :content_id, :symptom_id, :condition_id).tap do |attributes|
      attributes[:user] = current_user
      attributes[:image] = decode_b64_image(attributes[:image]) if attributes[:image]
    end
  end

  def send_robot_response!
    @consult.messages.create(user: Member.robot,
                             text: "We have received your message and your PHA will get back to you shortly. Thank you.",
                             created_at: Time.now + 1.second)
  end

  def send_robot_response?
    !(Metadata.find_by_mkey('remove_robot_response').try(:mvalue) == 'true')
  end

  def send_after_hours_response!
    @consult.messages.create(user: Member.robot,
                             text: 'Your PHA is currently unavailable. Please leave a brief message and our team will get back to you shortly. If you are experiencing a medical emergency, please call 911.',
                             created_at: Time.now + 2.seconds,
                             off_hours: true)
  end

  def needs_off_hours_response?
    return false unless off_hours?
    return false if @user != @consult.initiator
    if now.hour > 17 # same day off hours
      return false if @consult.messages
                              .where(off_hours: true)
                              .where('created_at > ?', off_hours_start_today)
                              .any?
    elsif now.hour < 9 # yesterday off hours
      return false if @consult.messages
                              .where(off_hours: true)
                              .where('created_at > ?', off_hours_start_yesterday)
                              .any?
    end
    true
  end

  def off_hours?
    now.saturday? || now.sunday? || now.hour < 9 || now.hour > 17
  end

  def now
    @now ||= Time.now.in_time_zone('Pacific Time (US & Canada)')
  end

  def yesterday
    @yesterday ||= now - 1.day
  end

  def off_hours_start_today
    Time.new(now.year, now.month, now.day, 17, 0, 0, now.utc_offset)
  end

  def off_hours_start_yesterday
    Time.new(yesterday.year, yesterday.month, yesterday.day, 17, 0, 0, yesterday.utc_offset)
  end
end
