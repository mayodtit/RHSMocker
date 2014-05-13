class Api::V1::ParsedNurselineRecordsController < Api::V1::ABaseController
  before_filter :authorize_pha!
  before_filter :load_parsed_nurseline_record!

  def show
    show_resource @parsed_nurseline_record
  end

  private

  def authorize_pha!
    raise CanCan::AccessDenied unless current_user.pha?
  end

  def load_parsed_nurseline_record!
    @parsed_nurseline_record = ParsedNurselineRecord.find(params[:id])
  end
end
