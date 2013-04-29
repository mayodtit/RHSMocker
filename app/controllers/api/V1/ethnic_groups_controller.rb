class Api::V1::EthnicGroupsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def list
    render_success(ethnic_group:EthnicGroup.all)
  end
end
