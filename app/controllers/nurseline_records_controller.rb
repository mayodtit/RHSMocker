class NurselineRecordsController < ApplicationController
  before_filter :authenticate_api_user!

  def create
    @record = NurselineRecord.create(params_from_request)
    if @record.errors.empty?
      head :created
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  private

  def authenticate_api_user!
    authenticate_or_request_with_http_token do |token, options|
      @api_user = ApiUser.find_by_auth_token(token)
      @api_user ? true : false
    end
  end

  def params_from_request
    {
      :api_user => @api_user,
      :payload => request.body.read
    }
  end
end
