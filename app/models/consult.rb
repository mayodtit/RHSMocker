class Consult < ActiveRecord::Base
  include SoftDeleteModule
  belongs_to :initiator, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :symptom
  has_many :messages, inverse_of: :consult, conditions: { note: false }
  has_many :messages_and_notes, class_name: 'Message', inverse_of: :consult
  has_many :users, through: :messages
  has_many :phone_calls, through: :messages
  has_many :scheduled_phone_calls, through: :messages
  has_many :cards, as: :resource, dependent: :destroy
  attr_accessor :skip_tasks
  has_many :conversation_transitions, class_name: 'ConsultConversationStateTransition'
  has_many :message_tasks
  belongs_to :delayed_job, class_name: 'Delayed::Backend::ActiveRecord::Job'

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
  after_commit :update_message_tasks, on: :update

  accepts_nested_attributes_for :messages
  mount_uploader :image, ConsultImageUploader

  def send_initial_message
    return if messages.any?
    return unless initiator.signed_up?
    return unless initiator.pha
    return if initiator.onboarding_group.try(:skip_automated_communications?)
    nux_answer_name = initiator.nux_answer.try(:name) || 'something else'

    if initiator.onboarding_group.try(:welcome_message_template)
      mt = initiator.onboarding_group.welcome_message_template
      mt.create_message initiator.pha, self, true, false, true if mt
    elsif initiator.free?
      MessageTemplate.find_by_name('Free Onboarding').try(:create_message, initiator.pha, self, true, true, true)
    elsif Role.pha.on_call?
      mt = MessageTemplate.find_by_name "New Premium Member Part 1: #{nux_answer_name}"
      mt.create_message initiator.pha, self, true, false, true if mt
      mt = MessageTemplate.find_by_name "New Premium Member Part 2: #{nux_answer_name}"
      mt.delay(run_at: Metadata.new_signup_second_message_delay.seconds.from_now).create_message(initiator.pha, self, false, false, true) if mt
    else
      mt = MessageTemplate.find_by_name "New Premium Member Off Hours: #{nux_answer_name}"
      mt.create_message initiator.pha, self, true, true, true if mt
    end

    self.reload
  end

  def self.deactivate_if_last_message(message_id)
    message = Message.find(message_id)
    Consult.transaction do
      consult = message.consult.lock!

      if consult.active? &&
         consult.messages.
           where(automated: false, note: false, off_hours: false).
           where('(system IS NULL OR system = 0) AND (text IS NOT NULL OR image IS NOT NULL) AND created_at > ?', message.created_at).count < 1
        consult.deactivate!
      end
    end
  end

  private

  state_machine initial: :open do
    event :close do
      transition :open => :closed
    end
  end

  state_machine :conversation_state, initial: :inactive do
    store_audit_trail

    event :activate do
      transition [:inactive, :needs_response, :active] => :active
    end

    event :deactivate do
      transition [:active, :needs_response] => :inactive
    end

    event :flag do
      transition [:active, :inactive] => :needs_response
    end

    before_transition any => [:active, :needs_response] do |consult, transition|
      if consult.delayed_job
        consult.delayed_job.destroy
        consult.delayed_job = nil
      end

      if transition.to == 'active' && message = transition.args.first
        consult.delayed_job = Consult.delay(run_at: Metadata.minutes_to_inactive_conversation.from_now).deactivate_if_last_message message.id
      end
    end
  end

  def update_message_tasks
    if previous_changes.include?('conversation_state')
      priority = case conversation_state.to_s
        when 'inactive' then MessageTask::INACTIVE_CONVERSATION_PRIORITY
        when 'active' then MessageTask::ACTIVE_CONVERSATION_PRIORITY
        when 'needs_response' then MessageTask::NEEDS_RESPONSE_PRIORITY
      end

      self.messages.reload
      MessageTask.where(consult_id: id).open.find_each do |m|
        m.update_attributes! priority: priority if m.message_id != self.messages.last.try(:id)
      end
    end
  end
end
