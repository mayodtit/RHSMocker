class Api::V1::EthnicGroupsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    index_resource(EthnicGroup.all)
  end
end
