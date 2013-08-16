class Encounter < ActiveRecord::Base
  has_many :encounter_users
  has_many :users, :through => :encounter_users
  has_many :messages
  has_many :phone_calls, :through => :messages

  attr_accessible :checked, :priority, :status, :add_user, :messages, :message

  validates :status, :priority, presence: true
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

  def self.open
    where(:status => :open)
  end

  def message=(message_params)
    self.messages.build(message_params.merge!(:encounter => self))
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
