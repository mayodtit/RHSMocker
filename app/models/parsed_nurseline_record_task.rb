class ParsedNurselineRecordTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :parsed_nurseline_record

  attr_accessible :parsed_nurseline_record, :parsed_nurseline_record_id

  validates :parsed_nurseline_record, presence: true

  private

  def set_defaults
    self.priority ||= 8
  end
end
