class Api::V1::ServiceStatusController < Api::V1::ABaseController
  def index
    if Role.pha.on_call?
      render_success(service_status: online_hash)
    else
      render_success(service_status: offline_hash)
    end
  end

  private

  def online_hash
    {
      status: :online
    }
  end

  def offline_hash
    {
      status: :offline,
      message: 'The PHA service is currently unavailable'
    }
  end
end
