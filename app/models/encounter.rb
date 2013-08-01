class Encounter < ActiveRecord::Base
  has_many :users, :through => :encounter_users
  has_many :messages
  has_many :phone_calls, :through => :messages
  has_many :encounter_users

  attr_accessible :checked, :priority, :status, :new_user

  validates :status, :priority, presence: true
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

  def self.open
    where(:status => :open)
  end

  def add_user=(user)
    users << user unless users.include?(user)
  end

  def serializable_hash(options={})
    options.reverse_merge!(:only => [:id, :status, :priority, :checked],
                           :include => :messages)
    super(options)
  end

  private

  def set_defaults
    self.status ||= 'open'
    self.priority ||= 'medium'
  end
end
