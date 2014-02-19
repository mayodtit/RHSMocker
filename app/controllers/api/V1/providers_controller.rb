class Api::V1::ProvidersController < Api::V1::ABaseController
  before_filter :load_providers!

  def index
    index_resource @providers, name: :users
  end

  private

  def load_providers!
    # remove whitespace from params
    [:first_name, :last_name].each { |k| params[k].strip! unless params[k].nil? }

    begin
      @providers = search_service.query(params)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
