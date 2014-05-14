class ParsedNurselineRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :consult
  belongs_to :phone_call
  belongs_to :nurseline_record

  attr_accessible :user, :user_id, :consult, :consult_id, :phone_call,
                  :phone_call_id, :nurseline_record, :nurseline_record_id,
                  :text

  validates :user, :consult, :phone_call, :nurseline_record, :text, presence: true
  validates :nurseline_record_id, uniqueness: true

  after_create :create_task

  def self.create_from_nurseline_record(nurseline_record)
    create(NurselineRecordParser.new(nurseline_record).parse!)
  end

  private

  def create_task
    ParsedNurselineRecordTask.create(parsed_nurseline_record: self,
                                     title: 'New Nurseline Record',
                                     creator: Member.robot,
                                     member: user,
                                     due_at: Time.now)
  end
end
