class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :consult
  belongs_to :content
  belongs_to :symptom
  belongs_to :condition
  belongs_to :phone_call, inverse_of: :message
  belongs_to :scheduled_phone_call, inverse_of: :message
  belongs_to :phone_call_summary, inverse_of: :message
  belongs_to :user_image, inverse_of: :messages
  has_many :message_statuses
  attr_accessor :no_notification

  attr_accessible :user, :user_id, :consult, :consult_id, :content,
                  :content_id, :phone_call, :phone_call_id,
                  :scheduled_phone_call, :scheduled_phone_call_id,
                  :phone_call_summary, :phone_call_summary_id, :text, :image,
                  :phone_call_attributes, :scheduled_phone_call_attributes,
                  :phone_call_summary_attributes,
                  :created_at, # for robot auto-response message
                  :symptom, :symptom_id, :condition, :condition_id,
                  :off_hours, :note, :user_image, :user_image_id,
                  :user_image_client_guid, :no_notification,
                  :system, :automated

  validates :user, :consult, presence: true
  validates :off_hours, inclusion: {in: [true, false]}
  validates :content, presence: true, if: lambda{|m| m.content_id}
  validates :symptom, presence: true, if: lambda{|m| m.symptom_id}
  validates :condition, presence: true, if: lambda{|m| m.condition_id}
  validates :phone_call, presence: true, if: lambda{|m| m.phone_call_id}
  validates :scheduled_phone_call, presence: true, if: lambda{|m| m.scheduled_phone_call_id}
  validates :phone_call_summary, presence: true, if: lambda{|m| m.phone_call_summary_id}
  validates :user_image, presence: true, if: ->(m){m.user_image_id}

  before_validation :set_user_from_association, on: :create
  before_validation :attach_user_image, if: ->(m){m.user_image_client_guid}, on: :create
  after_commit :publish, on: :create
  after_create :notify_initiator
  after_create :create_task
  after_create :update_initiator_last_contact_at
  after_create :activate_consult

  accepts_nested_attributes_for :phone_call
  accepts_nested_attributes_for :scheduled_phone_call
  accepts_nested_attributes_for :phone_call_summary
  mount_uploader :image, MessageImageUploader

  def publish
    PubSub.publish "/users/#{consult.initiator_id}/consults/#{consult_id}/messages/new", {id: id}
    if consult.master?
      PubSub.publish "/users/#{consult.initiator_id}/consults/current/messages/new", {id: id}
    end
  end

  def notify_initiator
    return if consult.initiator_id == user_id || note? || no_notification
    Notifications::NewMessageJob.create(consult.initiator_id, consult_id)
  end

  def create_task
    return if scheduled_phone_call_id.present? || phone_call_id.present? || note?
    MessageTask.create_if_only_opened_for_consult! consult, self
  end

  def exclude_id(id_array)
    id_array.include? self.id.to_s
  end

  def update_initiator_last_contact_at
    unless system? || phone_call_summary || (phone_call && phone_call.to_nurse?) || note? || user == consult.initiator
      consult.initiator.update_attributes! last_contact_at: self.created_at
    end
  end

  def activate_consult
    if !off_hours? && !system? && !automated? && !note? && (text.present? || image.present?)
      Consult.transaction do
        if user != consult.initiator
          consult.lock!.activate! self
        elsif !consult.lock!.needs_response?
          consult.flag!
        end
      end
    end
  end

  private

  def set_user_from_association
    self.user_id ||= phone_call.try(:user_id)
  end

  def attach_user_image
    self.user_image ||= UserImage.find_by_client_guid(user_image_client_guid)
  end
end
