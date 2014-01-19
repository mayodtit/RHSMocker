class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :consult
  belongs_to :content
  belongs_to :phone_call
  belongs_to :scheduled_phone_call
  belongs_to :phone_call_summary
  has_many :message_statuses

  attr_accessible :user, :user_id, :consult, :consult_id, :content,
                  :content_id, :phone_call, :phone_call_id,
                  :scheduled_phone_call, :scheduled_phone_call_id,
                  :phone_call_summary, :phone_call_summary_id, :text, :image

  validates :user, :consult, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id}
  validates :phone_call, presence: true, if: lambda{|m| m.phone_call_id}
  validates :scheduled_phone_call, presence: true, if: lambda{|m| m.scheduled_phone_call_id}
  validates :phone_call_summary, presence: true, if: lambda{|m| m.phone_call_summary_id}

  accepts_nested_attributes_for :phone_call
  accepts_nested_attributes_for :scheduled_phone_call
  accepts_nested_attributes_for :phone_call_summary
  mount_uploader :image, MessageImageUploader
end
