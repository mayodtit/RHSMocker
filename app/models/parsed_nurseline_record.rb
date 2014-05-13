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
end
