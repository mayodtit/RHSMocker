class Api::V1::ProviderCallLogsController < Api::V1::ABaseController
  def create
    create_resource ProviderCallLog, log_params
  end

  private

  def log_params
    params.require(:provider_call_log).permit(:npi, :number, :user_id)
  end
end