class Api::V1::ParsedNurselineRecordsController < Api::V1::ABaseController
  before_filter :authorize_pha!
  before_filter :load_parsed_nurseline_records!
  before_filter :load_parsed_nurseline_record!, only: :show

  def index
    parsed_nurseline_records_desc = @parsed_nurseline_records.order('created_at DESC')
    index_resource parsed_nurseline_records_desc.serializer
  end

  def show
    show_resource @parsed_nurseline_record.serializer(include_text: true)
  end

  private

  def authorize_pha!
    raise CanCan::AccessDenied unless current_user.pha?
  end

  def load_parsed_nurseline_records!
    @parsed_nurseline_records = ParsedNurselineRecord.scoped
  end

  def load_parsed_nurseline_record!
    @parsed_nurseline_record = @parsed_nurseline_records.find(params[:id])
  end
end
