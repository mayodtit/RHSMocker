class Consult < ActiveRecord::Base
  belongs_to :initiator, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :symptom
  has_many :messages, inverse_of: :consult, conditions: { note: false }, order: 'created_at ASC'
  has_many :messages_and_notes, class_name: 'Message', inverse_of: :consult, order: 'created_at ASC'
  has_many :users, through: :messages
  has_many :phone_calls, through: :messages
  has_many :scheduled_phone_calls, through: :messages
  has_many :cards, as: :resource, dependent: :destroy
  attr_accessor :skip_tasks

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :symptom,
                  :symptom_id, :state, :title, :description, :image,
                  :messages_attributes, :master, :skip_tasks

  # Interestingly enough, Rails uses the attr_accessible list in order to build
  # the params hash for the resource key when one is not specified.  As a result
  # in order to make the following keys appear in the resource params, we need
  # to put them in the attr_accessible list.  In the future, enforce that the
  # client must specify the resource key (I think).
  # TODO - remove this after sync up with client
  attr_accessible :message, :phone_call, :scheduled_phone_call

  validates :initiator, :subject, :state, :title, presence: true
  validates :symptom, presence: true, if: lambda{|c| c.symptom_id.present? }
  validates :master, inclusion: {in: [true, false]}
  validates :master, uniqueness: {scope: :initiator_id}, if: :master?

  before_validation :strip_attributes
  after_create :send_initial_message
  after_save :update_tasks, unless: :skip_tasks?

  accepts_nested_attributes_for :messages
  mount_uploader :image, ConsultImageUploader

  def update_tasks
    return if id_changed?
  end

  def send_initial_message
    return if messages.any?
    return unless initiator.signed_up?
    return unless initiator.pha
    if Metadata.new_onboarding_flow?
      nux_answer_name = initiator.nux_answer.try(:name) || 'something else'

      if Role.pha.on_call?
        mt = MessageTemplate.find_by_name "New Premium Member Part 1: #{nux_answer_name}"
        mt.create_message initiator.pha, self, true, false, true if mt
        mt = MessageTemplate.find_by_name "New Premium Member Part 2: #{nux_answer_name}"
        mt.delay(run_at: Metadata.new_signup_second_message_delay.seconds.from_now).create_message(initiator.pha, self, false, false, true) if mt
      else
        mt = MessageTemplate.find_by_name "New Premium Member Off Hours: #{nux_answer_name}"
        mt.create_message initiator.pha, self, true, false, true if mt
      end

      self.reload
    else
      mt = MessageTemplate.find_by_name 'New Premium Member OLD'
      mt.create_message initiator.pha, self, true if mt
      self.reload
    end
  end

  def self.deactivate_if_last_message(message_id)
    message = Message.find(message_id)
    consult = message.consult

    consult.deactivate! if consult.active? && consult.messages.where(automated: false, system: false, off_hours: false).where('created_at > ?', message.created_at).count < 1
  end

  private

  state_machine initial: :open do
    event :close do
      transition :open => :closed
    end
  end

  state_machine :conversation_state, initial: :inactive do
    event :activate do
      transition [:inactive, :needs_response] => :active
    end

    event :deactivate do
      transition [:active, :needs_response] => :inactive
    end

    event :flag do
      transition [:active, :inactive] => :needs_response
    end

    after_transition any => :inactive do |consult|
      MessageTask.where(consult_id: consult.id).open.find_each do |m|
        m.update_attributes! priority: MessageTask::INACTIVE_CONVERSATION_PRIORITY
      end
    end

    after_transition any => :active do |consult|
      MessageTask.where(consult_id: consult.id).open.find_each do |m|
        m.update_attributes! priority: MessageTask::ACTIVE_CONVERSATION_PRIORITY
      end
    end

    after_transition any => :needs_response do |consult|
      MessageTask.where(consult_id: consult.id).open.find_each do |m|
        m.update_attributes! priority: MessageTask::NEEDS_RESPONSE_PRIORITY
      end
    end
  end

  def skip_tasks?
    @skip_tasks || false
  end
end
