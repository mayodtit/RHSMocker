class ParsedNurselineRecordTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :member
  belongs_to :parsed_nurseline_record

  attr_accessible :member, :member_id, :parsed_nurseline_record,
                  :parsed_nurseline_record_id

  validates :member, :parsed_nurseline_record, presence: true
end
