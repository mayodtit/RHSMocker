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
                  :created_at, # for robot auto-response message
                  :unread_by_cp

  validates :user, :consult, presence: true
  validates :content, presence: true, if: lambda{|m| m.content_id}
  validates :phone_call, presence: true, if: lambda{|m| m.phone_call_id}
  validates :scheduled_phone_call, presence: true, if: lambda{|m| m.scheduled_phone_call_id}
  validates :phone_call_summary, presence: true, if: lambda{|m| m.phone_call_summary_id}

  before_validation :set_unread_by_cp, on: :create
  after_save :publish

  accepts_nested_attributes_for :phone_call
  accepts_nested_attributes_for :scheduled_phone_call
  accepts_nested_attributes_for :phone_call_summary
  mount_uploader :image, MessageImageUploader

  def set_unread_by_cp
    return unless unread_by_cp.nil?

    if phone_call_id || scheduled_phone_call_id
      self.unread_by_cp = false
      return
    end

    self.unread_by_cp = true
  end

  def publish
    if id_changed?
      if scheduled_phone_call_id.nil? && phone_call_id.nil?
        PubSub.publish "/users/#{consult.initiator_id}/consults/#{consult_id}/messages/new", {id: id}
        PubSub.publish "/messages/new", {id: id}
      end
    else
      if unread_by_cp_changed?
        PubSub.publish "/messages/update/read", {id: id}
      end
    end
  end
end
