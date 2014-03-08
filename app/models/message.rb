class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :consult
  belongs_to :content
  belongs_to :phone_call, inverse_of: :message
  belongs_to :scheduled_phone_call, inverse_of: :message
  belongs_to :phone_call_summary, inverse_of: :message
  has_many :message_statuses

  attr_accessible :user, :user_id, :consult, :consult_id, :content,
                  :content_id, :phone_call, :phone_call_id,
                  :scheduled_phone_call, :scheduled_phone_call_id,
                  :phone_call_summary, :phone_call_summary_id, :text, :image,
                  :phone_call_attributes, :scheduled_phone_call_attributes,
                  :phone_call_summary_attributes,
                  :created_at # for robot auto-response message

  validates :user, :consult, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id}
  validates :phone_call, presence: true, if: lambda{|m| m.phone_call_id}
  validates :scheduled_phone_call, presence: true, if: lambda{|m| m.scheduled_phone_call_id}
  validates :phone_call_summary, presence: true, if: lambda{|m| m.phone_call_summary_id}

  after_create :publish
  after_create :create_task

  accepts_nested_attributes_for :phone_call
  accepts_nested_attributes_for :scheduled_phone_call
  accepts_nested_attributes_for :phone_call_summary
  mount_uploader :image, MessageImageUploader

  def publish
    PubSub.publish "/users/#{consult.initiator_id}/consults/#{consult_id}/messages/new", {id: id}
  end

  def create_task
    return if scheduled_phone_call_id.present? || phone_call_id.present?
    Task.create_unique_open_message_for_consult! consult, self
  end
end
