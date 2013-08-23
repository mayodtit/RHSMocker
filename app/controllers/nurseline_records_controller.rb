class NurselineRecordsController < ApplicationController
  def create
    @record = NurselineRecord.create(params_from_request)
    if @record.errors.empty?
      head :created
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  private

  def params_from_request
    {:payload => request.body.read}
  end
end
