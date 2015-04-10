class Api::V1::ServiceStatusController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  
  def index
    if !Rails.env.production? && (params[:force_status] == 'online')
      render_success(service_status: online_hash)
    elsif !Rails.env.production? && (params[:force_status] == 'offline')
      render_success(service_status: offline_hash)
    elsif Role.pha.on_call?
      render_success(service_status: online_hash)
    else
      render_success(service_status: offline_hash)
    end
  end

  private

  def online_hash
    {
      status: :online,
      title: 'Your PHA',
      status_message: 'ONLINE',
      background_top_color: 'e1e2e2',
      background_bottom_color: 'e1e2e2'
    }
  end

  def offline_hash
    {
      status: :offline,
      title: 'Your PHA',
      status_message: 'OFFLINE',
      message: "Our PHA team is currently offline, but send them a message " +
               "and they will get back to you shortly.\n\n" +
               "If this is an emergency, call 911.\n\n" +
               "Tap the phone button above to connect to the Mayo Clinic " +
               "Nurse Line.",
      background_top_color: '223351',
      background_bottom_color: '7da5a0'
    }
  end
end
