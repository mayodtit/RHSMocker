class ParsedNurselineRecordTask < Task
  include ActiveModel::ForbiddenAttributesProtection
  PRIORITY = 8

  belongs_to :parsed_nurseline_record

  attr_accessible :parsed_nurseline_record, :parsed_nurseline_record_id

  validates :parsed_nurseline_record, presence: true
  
  def default_queue
    :hcc
  end

  def set_priority
    self.priority = PRIORITY
  end
end
