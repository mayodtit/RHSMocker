class Consult < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'Member'
  belongs_to :subject, :class_name => 'User'
  has_many :consult_users
  has_many :users, :through => :consult_users
  has_many :messages
  has_many :scheduled_phone_calls, :through => :messages
  has_many :phone_calls, :through => :messages

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :checked,
                  :priority, :status, :add_user, :messages, :message

  validates :initiator, :subject, :status, :priority, presence: true
  validates :subject_id, :uniqueness => {:scope => :initiator_id}
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

  def self.open
    where(:status => :open)
  end

  def message=(message_params)
    self.messages.build(message_params.merge!(:consult => self))
  end

  def add_user=(user)
    self.users << user unless self.users.include?(user)
  end

  def serializable_hash(options=nil)
    options ||= {}
    options.reverse_merge!(:only => [:id, :status, :priority, :checked],
                           :include => :messages)
    super(options)
  end

  def members
    users.where(:type => 'Member')
  end

  private

  def set_defaults
    self.status ||= 'open'
    self.priority ||= 'medium'
    self.checked = false if checked.nil?
    true
  end
end
