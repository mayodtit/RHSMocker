class Consult < ActiveRecord::Base
  belongs_to :initiator, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :symptom
  has_many :messages, inverse_of: :consult, order: 'created_at ASC'
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

  private

  state_machine initial: :open do
    event :close do
      transition :open => :closed
    end
  end

  WELCOME_MESSAGE_TEXT = "Welcome to Better. As your PHA, the first thing "\
    "I’d like to help you do is get in touch with me. Tap on my photo to "\
    "read my bio, tap on the phone above to call or just start typing to "\
    "send a message. Try it now; just say hello."

  def send_initial_message
    return if messages.any?
    return unless initiator.pha
    messages.create(user: initiator.pha, text: WELCOME_MESSAGE_TEXT)
  end

  def skip_tasks?
    @skip_tasks || false
  end
end
